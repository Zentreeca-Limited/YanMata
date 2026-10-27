class AiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isEmergency;
  final List<String> citations;
  final List<Map<String, String>> helplines;
  final List<String> suggestedActions;
  final List<String> followUps;

  const AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isEmergency = false,
    this.citations = const [],
    this.helplines = const [],
    this.suggestedActions = const [],
    this.followUps = const [],
  });
}

class CycleInsightsModel {
  final String regularity;
  final String phase;
  final int dayOfCycle;
  final int totalDays;
  final String energyOutlook;
  final int nextPeriodInDays;
  final Map<String, int> fertileWindow;
  final List<String> tailoredTips;

  const CycleInsightsModel({
    required this.regularity,
    required this.phase,
    required this.dayOfCycle,
    required this.totalDays,
    required this.energyOutlook,
    required this.nextPeriodInDays,
    required this.fertileWindow,
    required this.tailoredTips,
  });

  factory CycleInsightsModel.fromJson(Map<String, dynamic> json) {
    final fw = json['fertile_window'] as Map<String, dynamic>? ?? {};
    return CycleInsightsModel(
      regularity: json['regularity'] as String? ?? 'Regular',
      phase: json['phase'] as String? ?? 'Follicular Phase',
      dayOfCycle: json['day_of_cycle'] as int? ?? 12,
      totalDays: json['total_days'] as int? ?? 28,
      energyOutlook: json['energy_outlook'] as String? ?? '',
      nextPeriodInDays: json['next_period_in_days'] as int? ?? 16,
      fertileWindow: {
        'start_day': fw['start_day'] as int? ?? 10,
        'end_day': fw['end_day'] as int? ?? 16,
      },
      tailoredTips: (json['tailored_tips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
