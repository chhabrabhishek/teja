import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/api/api_exception.dart';
import '../../data/auth_repository.dart';
import '../../data/push_repository.dart';
import '../../domain/models.dart';

enum AuthStatus { unknown, signedOut, signedIn }

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.busy = false,
    this.error,
    this.isNewUser = false,
    this.pendingEmail,
    this.codeErrorSignal = 0,
  });

  final AuthStatus status;
  final TejaUser? user;
  final bool busy;
  final String? error;
  final bool isNewUser;
  final String? pendingEmail;
  final int codeErrorSignal;

  AuthState copyWith({
    AuthStatus? status,
    TejaUser? user,
    bool? busy,
    String? error,
    bool? isNewUser,
    String? pendingEmail,
    int? codeErrorSignal,
    bool clearError = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        busy: busy ?? this.busy,
        error: clearError ? null : (error ?? this.error),
        isNewUser: isNewUser ?? this.isNewUser,
        pendingEmail: pendingEmail ?? this.pendingEmail,
        codeErrorSignal: codeErrorSignal ?? this.codeErrorSignal,
      );
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // A revoked refresh token signs the user out from anywhere in the app.
    ref.listen(sessionRevokedProvider, (_, __) => _forceSignOut());
    Future.microtask(restore);
    return const AuthState();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> restore() async {
    await _repo.restore();
    if (!_repo.hasSession) {
      state = state.copyWith(status: AuthStatus.signedOut);
      return;
    }
    try {
      final user = await _repo.me();
      state = state.copyWith(status: AuthStatus.signedIn, user: user);
    } on ApiException {
      state = state.copyWith(status: AuthStatus.signedOut);
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final name = [credential.givenName, credential.familyName]
          .whereType<String>()
          .join(' ')
          .trim();
      final session = await _repo.signInWithApple(
        identityToken: credential.identityToken ?? '',
        fullName: name.isEmpty ? null : name,
        timezone: await localTimezone(),
      );
      _apply(session);
    } on SignInWithAppleAuthorizationException {
      // The user cancelled. Cancelling is not an error; say nothing.
      state = state.copyWith(busy: false);
    } on ApiException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
    }
  }

  Future<bool> requestEmailCode(String email) async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      await _repo.requestEmailCode(email.trim());
      state = state.copyWith(busy: false, pendingEmail: email.trim());
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    }
  }

  Future<bool> verifyEmailCode(String code) async {
    final email = state.pendingEmail;
    if (email == null) return false;
    state = state.copyWith(busy: true, clearError: true);
    try {
      _apply(await _repo.verifyEmailCode(email, code, await localTimezone()));
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        busy: false,
        error: e.message,
        codeErrorSignal: state.codeErrorSignal + 1,
      );
      return false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> patch) async {
    final user = await _repo.updateMe(patch);
    state = state.copyWith(user: user);
  }

  void refreshUser(TejaUser user) => state = state.copyWith(user: user);

  /// Called after a publish so the streak on Profile is correct immediately.
  void applyStreak(Streak streak) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(user: user.copyWith(streak: streak));
  }

  Future<void> signOut() async {
    await ref.read(pushRepositoryProvider).unregister();
    await _repo.signOut();
    _forceSignOut();
  }

  Future<void> deleteAccount() async {
    await _repo.deleteAccount();
    _forceSignOut();
  }

  void _apply(Session session) {
    state = AuthState(
      status: AuthStatus.signedIn,
      user: session.user,
      isNewUser: session.isNewUser,
    );
  }

  void _forceSignOut() => state = const AuthState(status: AuthStatus.signedOut);
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
