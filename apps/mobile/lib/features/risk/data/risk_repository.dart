import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/risk/domain/risk_assessment.dart';

class RiskRepository {
  RiskRepository({Api? api}) : _api = api ?? Api();
  final Api _api;

  static const RiskAssessmentData defaultAssessment = RiskAssessmentData(
    id: 'default-risk-id',
    ageGroup: 'Adolescence (15–19)',
    overallRiskScore: 38,
    overallRiskLabel: 'Moderate',
    cervicalRiskScore: 38,
    breastRiskScore: 22,
    hormonalRiskScore: 41,
    completedSections: {
      'Age & Personal Details': 'Completed',
      'Menstrual Cycle': 'Completed',
      'Reproductive History': 'Completed',
      'Medical History': 'Completed',
      'Lifestyle & Habits': 'In progress',
      'Family History': 'Optional',
    },
    keyFactors: {
      'Cervical': [
        'Last screening 2 years ago (Recommended: every 3 years)',
        'HPV vaccination not recorded in profile',
        'Family history of cervical health conditions',
        'History of irregular bleeding or spotting',
      ],
      'Breast': [
        'No clinical breast exam recorded in the last 12 months',
        'No known early-onset family history',
        'Monthly self-awareness checks encouraged',
      ],
      'Hormonal': [
        'Irregular cycle intervals reported in tracker',
        'Occasional severe pelvic pain or cramps',
        'Daily stress levels rated moderate',
      ],
      'General': [
        'General lifestyle: active, non-smoker',
        'Recommended hydration: 2L daily',
        'Annual routine check-up due in 4 months',
      ],
    },
    recommendations: [
      'Get screened regularly (Pap smear / HPV test in Jos)',
      'Consider HPV vaccination (if eligible under FMOH guidelines)',
      'Adopt healthy lifestyle and stress-reduction habits',
      'Track cycle symptoms consistently for 3 months',
    ],
    traceableSource:
        'WHO Cervical Cancer Elimination Initiative & Federal Ministry of Health Nigeria Guidelines',
  );

  Future<RiskAssessmentData> fetchAssessment({String? token}) async {
    try {
      final res = await _api.request('/risk-profile', token: token);
      final data = res['data'];
      if (data != null && data is Map<String, dynamic>) {
        return RiskAssessmentData.fromJson(data);
      }
      return defaultAssessment;
    } catch (_) {
      return defaultAssessment;
    }
  }

  Future<RiskAssessmentData> saveAssessment(
    RiskAssessmentData assessment, {
    String? token,
  }) async {
    try {
      final res = await _api.request(
        '/risk-profile',
        method: 'POST',
        body: assessment.toJson(),
        token: token,
      );
      final data = res['data'];
      if (data != null && data is Map<String, dynamic>) {
        return RiskAssessmentData.fromJson(data);
      }
      return assessment;
    } catch (_) {
      return assessment;
    }
  }
}
