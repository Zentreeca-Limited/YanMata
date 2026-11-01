import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/providers.dart';
import 'package:yanmata/features/account/data/account_repository.dart';
import 'package:yanmata/features/account/domain/health_profile.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(api: ref.watch(apiProvider));
});

class HealthProfileNotifier extends AsyncNotifier<HealthProfile> {
  AccountRepository get _repo => ref.read(accountRepositoryProvider);

  @override
  Future<HealthProfile> build() async {
    final token = ref.watch(journalProvider).value?.token;
    return _repo.fetchProfile(token: token);
  }

  Future<void> updateSection(
    String sectionKey,
    Map<String, dynamic> sectionData,
  ) async {
    final token = ref.read(journalProvider).value?.token;
    final current = state.value ?? const HealthProfile();
    final updatedAnswers = Map<String, dynamic>.from(current.answers);
    updatedAnswers[sectionKey] = sectionData;

    state = const AsyncLoading();
    try {
      final updated = await _repo.updateProfile(updatedAnswers, token: token);
      state = AsyncData(updated);
      ref.invalidate(personalizedInsightsProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> saveFullAnswers(Map<String, dynamic> fullAnswers) async {
    final token = ref.read(journalProvider).value?.token;
    state = const AsyncLoading();
    try {
      final updated = await _repo.updateProfile(fullAnswers, token: token);
      state = AsyncData(updated);
      ref.invalidate(personalizedInsightsProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final healthProfileProvider =
    AsyncNotifierProvider<HealthProfileNotifier, HealthProfile>(
      HealthProfileNotifier.new,
    );

final personalizedInsightsProvider = FutureProvider<List<PersonalizedInsight>>((
  ref,
) async {
  final token = ref.watch(journalProvider).value?.token;
  if (token == null) return [];
  final repo = ref.watch(accountRepositoryProvider);
  return repo.fetchInsights(token: token);
});
