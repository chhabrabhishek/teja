/// Copy helpers. Teja's voice is warm, short, and never punitive — so date
/// formatting lives here rather than being scattered through widgets.
extension TejaDateX on DateTime {
  static const _weekdays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'
  ];
  static const _months = [
    'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
    'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
  ];

  /// "TUESDAY · 16 SEPTEMBER"
  String get eyebrowLabel => '${_weekdays[weekday - 1]} · $day ${_months[month - 1]}';

  /// "2h", "4m", "just now" — short, never "4 minutes ago".
  String get shortAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '$day ${_months[month - 1].substring(0, 3).toLowerCase()}';
  }
}

/// The Today countdown. Calm above 3 hours, gently urgent below it.
String timeRemainingLabel(int seconds, {required bool createdToday}) {
  if (createdToday) return '';
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  if (hours >= 3) return '${hours}h ${minutes}m left today';
  if (hours >= 1) return 'Just over ${hours}h left';
  return '$minutes minutes left today';
}

/// The streak-at-risk nudge. No red, no alarm, no shaking — a hand on the back.
String nudgeFor({
  required int secondsRemaining,
  required int streak,
  required bool createdToday,
  required String promptNudge,
}) {
  if (createdToday) return 'Come back tomorrow for a new one.';
  if (streak > 0 && secondsRemaining < 3 * 3600) {
    return 'A few hours left to keep day $streak alive.';
  }
  return promptNudge;
}
