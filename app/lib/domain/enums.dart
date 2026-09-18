/// Activity categories. One per day, on a fixed weekly rotation.
enum Craft {
  writing('writing', 'Creative Writing', 'Words on a page.'),
  photo('photo', 'Photography', 'Look again at what you already see.'),
  sketch('sketch', 'Sketch / Art', 'Lines, not masterpieces.'),
  joke('joke', 'Joke', 'Make one person laugh.');

  const Craft(this.id, this.label, this.blurb);

  final String id;
  final String label;
  final String blurb;

  static Craft from(String? id) =>
      Craft.values.firstWhere((c) => c.id == id, orElse: () => Craft.writing);

  /// What Compose should render.
  bool get isImage => this == Craft.photo || this == Craft.sketch;

  /// The joke category is a one-liner, and the limit is part of the fun.
  int? get characterLimit => this == Craft.joke ? 280 : null;

  String get placeholder => switch (this) {
        Craft.writing => 'Start anywhere…',
        Craft.photo => 'Add a caption (optional)',
        Craft.sketch => 'Add a caption (optional)',
        Craft.joke => 'Punchline first?',
      };
}

enum SubmissionStatus { draft, published }

enum ComposeSaveState { idle, saving, saved, failed }
