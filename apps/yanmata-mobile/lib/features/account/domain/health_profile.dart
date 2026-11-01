class HealthProfile {
  final int age;
  final bool isMinor;
  final List<String> requiredSections;
  final Map<String, dynamic> answers;
  final bool completed;

  const HealthProfile({
    this.age = 18,
    this.isMinor = false,
    this.requiredSections = const ['menstrual', 'lifestyle'],
    this.answers = const {},
    this.completed = false,
  });

  factory HealthProfile.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'];
    Map<String, dynamic> parsedAnswers = {};
    if (rawAnswers is Map) {
      parsedAnswers = Map<String, dynamic>.from(rawAnswers);
    }

    final rawSections = json['required_sections'];
    List<String> parsedSections = [];
    if (rawSections is List) {
      parsedSections = rawSections.map((e) => e.toString()).toList();
    }

    return HealthProfile(
      age: (json['age'] as num?)?.toInt() ?? 18,
      isMinor: json['is_minor'] as bool? ?? false,
      requiredSections: parsedSections,
      answers: parsedAnswers,
      completed: json['completed'] as bool? ?? false,
    );
  }

  HealthProfile copyWith({
    int? age,
    bool? isMinor,
    List<String>? requiredSections,
    Map<String, dynamic>? answers,
    bool? completed,
  }) {
    return HealthProfile(
      age: age ?? this.age,
      isMinor: isMinor ?? this.isMinor,
      requiredSections: requiredSections ?? this.requiredSections,
      answers: answers ?? this.answers,
      completed: completed ?? this.completed,
    );
  }
}

class PersonalizedInsight {
  final String id;
  final String category;
  final String priority;
  final String title;
  final String body;
  final String source;
  final String reviewStatus;

  const PersonalizedInsight({
    required this.id,
    required this.category,
    required this.priority,
    required this.title,
    required this.body,
    required this.source,
    required this.reviewStatus,
  });

  factory PersonalizedInsight.fromJson(Map<String, dynamic> json) {
    return PersonalizedInsight(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      priority: json['priority'] as String? ?? 'routine',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      source: json['source'] as String? ?? 'WHO & FMOH Nigeria Guidelines',
      reviewStatus:
          json['review_status'] as String? ?? 'pending_clinical_review',
    );
  }
}
