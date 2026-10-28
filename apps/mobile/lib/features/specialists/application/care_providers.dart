import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../journal/application/journal_controller.dart';
import '../data/care_repository.dart';
import '../domain/specialist.dart';

final careRepositoryProvider = Provider<CareRepository>(
  (ref) => RemoteCareRepository(ref.watch(apiProvider)),
);

final specialistsProvider = FutureProvider<List<Specialist>>((ref) async {
  final repo = ref.watch(careRepositoryProvider);
  return repo.getSpecialists();
});

final myCareRequestsProvider =
    AsyncNotifierProvider<MyCareRequestsNotifier, List<SupportRequestItem>>(
      MyCareRequestsNotifier.new,
    );

class MyCareRequestsNotifier extends AsyncNotifier<List<SupportRequestItem>> {
  CareRepository get _repo => ref.read(careRepositoryProvider);

  String? get _token => ref.read(journalProvider).value?.token;

  @override
  Future<List<SupportRequestItem>> build() async {
    final token = _token;
    if (token == null) return [];
    return _repo.getMyRequests(token);
  }

  Future<void> refresh() async {
    final token = _token;
    if (token == null) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.getMyRequests(token));
  }

  Future<SupportRequestItem> createRequest({
    required String topic,
    required String stage,
    required String summary,
    required bool shareJournalConsent,
    String? specialistId,
  }) async {
    final token = _token;
    if (token == null) {
      throw StateError('Sign in to contact a specialist.');
    }
    final item = await _repo.createRequest(
      token,
      topic: topic,
      stage: stage,
      summary: summary,
      shareJournalConsent: shareJournalConsent,
      specialistId: specialistId,
    );
    await refresh();
    return item;
  }
}

final careConversationProvider =
    FutureProvider.family<CareConversationItem?, String>((
      ref,
      conversationId,
    ) async {
      final token = ref.watch(journalProvider).value?.token;
      if (token == null) return null;
      return ref
          .watch(careRepositoryProvider)
          .getConversation(token, conversationId);
    });

extension CareActions on WidgetRef {
  Future<void> sendCareMessage(String conversationId, String body) async {
    final token = read(journalProvider).value?.token;
    if (token == null) throw StateError('Unauthenticated.');
    await read(careRepositoryProvider).sendMessage(token, conversationId, body);
    invalidate(careConversationProvider(conversationId));
  }
}
