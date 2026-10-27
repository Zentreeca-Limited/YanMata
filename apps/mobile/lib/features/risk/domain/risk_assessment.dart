class RiskAssessmentData {
  const RiskAssessmentData({
    required this.id,
    required this.ageGroup,
    required this.overallRiskScore,
    required this.overallRiskLabel,
    required this.cervicalRiskScore,
    required this.breastRiskScore,
    required this.hormonalRiskScore,
    required this.completedSections,
    required this.keyFactors,
    required this.recommendations,
    required this.traceableSource,
  });

  final String id;
  final String ageGroup;
  final int overallRiskScore;
  final String overallRiskLabel;
  final int cervicalRiskScore;
  final int breastRiskScore;
  final int hormonalRiskScore;
  final Map<String, String> completedSections;
  final Map<String, List<String>> keyFactors;
  final List<String> recommendations;
  final String traceableSource;

  factory RiskAssessmentData.fromJson(Map<String, dynamic> json) {
    Map<String, String> parseSections(dynamic raw) {
      if (raw is Map) {
        return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
      return {};
    }

    Map<String, List<String>> parseFactors(dynamic raw) {
      if (raw is Map) {
        return raw.map((k, v) {
          if (v is List) {
            return MapEntry(k.toString(), v.map((e) => e.toString()).toList());
          }
          return MapEntry(k.toString(), <String>[]);
        });
      }
      return {};
    }

    List<String> parseList(dynamic raw) {
      if (raw is List) return raw.map((e) => e.toString()).toList();
      return [];
    }

    return RiskAssessmentData(
      id: json['id'] as String? ?? 'default-risk',
      ageGroup: json['age_group'] as String? ?? 'Adolescence (15–19)',
      overallRiskScore: (json['overall_risk_score'] as num?)?.toInt() ?? 38,
      overallRiskLabel: json['overall_risk_label'] as String? ?? 'Moderate',
      cervicalRiskScore: (json['cervical_risk_score'] as num?)?.toInt() ?? 38,
      breastRiskScore: (json['breast_risk_score'] as num?)?.toInt() ?? 22,
      hormonalRiskScore: (json['hormonal_risk_score'] as num?)?.toInt() ?? 41,
      completedSections: parseSections(json['completed_sections']),
      keyFactors: parseFactors(json['key_factors']),
      recommendations: parseList(json['recommendations']),
      traceableSource: json['traceable_source'] as String? ??
          'WHO Cervical Cancer Elimination Initiative & Federal Ministry of Health Nigeria Guidelines',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'age_group': ageGroup,
    'overall_risk_score': overallRiskScore,
    'overall_risk_label': overallRiskLabel,
    'cervical_risk_score': cervicalRiskScore,
    'breast_risk_score': breastRiskScore,
    'hormonal_risk_score': hormonalRiskScore,
    'completed_sections': completedSections,
    'key_factors': keyFactors,
    'recommendations': recommendations,
    'traceable_source': traceableSource,
  };
}
