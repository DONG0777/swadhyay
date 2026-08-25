class SuryaNamaskarContent {
  final String id;
  final int stepNumber;
  final String languageCode;
  final String title;
  final String? mantra;
  final String? mantraTransliteration;
  final String? mantraMeaning;
  final String? description;
  final String? imageUrl;
  final String? instructions;
  final String? benefits;

  const SuryaNamaskarContent({
    required this.id,
    required this.stepNumber,
    required this.languageCode,
    required this.title,
    this.mantra,
    this.mantraTransliteration,
    this.mantraMeaning,
    this.description,
    this.imageUrl,
    this.instructions,
    this.benefits,
  });
}
