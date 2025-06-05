  class KYRModel {
    final String title;
    final String category;
    final String language;
    final String description;
    final String legalBasis;
    final List<String> actionPoints;

    KYRModel({
      required this.title,
      required this.category,
      required this.language,
      required this.description,
      required this.legalBasis,
      required this.actionPoints,
    });

    factory KYRModel.fromJson(Map<String, dynamic> json) {
      // Defensive: ensure actionPoints is always a List<String>
      List<String> actionPoints = [];
      if (json['action_points'] is List) {
        actionPoints = (json['action_points'] as List)
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }

      return KYRModel(
        title: (json['title'] ?? '').toString(),
        category: (json['category'] ?? '').toString(),
        language: (json['language'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        legalBasis: (json['legal_basis'] ?? '').toString(),
        actionPoints: actionPoints,
      );
    }
  }
