import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/risk/data/risk_repository.dart';
import 'package:yanmata/features/risk/domain/risk_assessment.dart';

final riskRepositoryProvider = Provider<RiskRepository>((ref) {
  return RiskRepository();
});

class RiskAssessmentNotifier extends AsyncNotifier<RiskAssessmentData> {
  RiskRepository get _repo => ref.read(riskRepositoryProvider);

  @override
  Future<RiskAssessmentData> build() async {
    return _repo.fetchAssessment();
  }

  Future<void> updateSection(String sectionKey, String status) async {
    final current = state.value ?? RiskRepository.defaultAssessment;
    final updatedSections = Map<String, String>.from(current.completedSections);
    updatedSections[sectionKey] = status;

    final updated = RiskAssessmentData(
      id: current.id,
      ageGroup: current.ageGroup,
      overallRiskScore: current.overallRiskScore,
      overallRiskLabel: current.overallRiskLabel,
      cervicalRiskScore: current.cervicalRiskScore,
      breastRiskScore: current.breastRiskScore,
      hormonalRiskScore: current.hormonalRiskScore,
      completedSections: updatedSections,
      keyFactors: current.keyFactors,
      recommendations: current.recommendations,
      traceableSource: current.traceableSource,
    );

    state = AsyncData(updated);
    await _repo.saveAssessment(updated);
  }
}

final riskAssessmentProvider =
    AsyncNotifierProvider<RiskAssessmentNotifier, RiskAssessmentData>(
      RiskAssessmentNotifier.new,
    );
