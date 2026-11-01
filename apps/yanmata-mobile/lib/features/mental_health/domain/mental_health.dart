class MentalHealthTopic {
  const MentalHealthTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.copingTips,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String description;
  final List<String> copingTips;
}
