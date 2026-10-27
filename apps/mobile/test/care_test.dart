import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';
import 'package:yanmata/features/learning/application/learning_provider.dart';
import 'package:yanmata/features/specialists/application/care_providers.dart';
import 'package:yanmata/features/specialists/data/care_repository.dart';
import 'package:yanmata/features/specialists/domain/specialist.dart';
import 'package:yanmata/main.dart';

import 'widget_test.dart' show MemoryStore;

class FakeCareRepository implements CareRepository {
  final List<Specialist> specialists = [
    const Specialist(
      id: 'spec-1',
      name: 'Dr. Fatima Bello',
      title: 'Obstetrician & Gynaecologist',
      credentials: 'MBBS, FWACS (OB/GYN)',
      specialty: 'Reproductive health & midlife',
      bio: 'Consultant in Jos',
      city: 'Jos, Plateau State',
      verificationSource: 'MDCN #94821',
      isVerified: true,
      isAvailable: true,
    ),
  ];

  final List<SupportRequestItem> requests = [];

  @override
  Future<List<Specialist>> getSpecialists() async => specialists;

  @override
  Future<List<SupportRequestItem>> getMyRequests(String token) async => requests;

  @override
  Future<SupportRequestItem> createRequest(
    String token, {
    required String topic,
    required String stage,
    required String summary,
    required bool shareJournalConsent,
    String? specialistId,
  }) async {
    final item = SupportRequestItem(
      id: 'req-1',
      topic: topic,
      stage: stage,
      summary: summary,
      status: 'assigned',
      shareJournalConsent: shareJournalConsent,
      specialistId: specialistId,
      conversationId: 'conv-1',
      specialist: specialists.first,
    );
    requests.add(item);
    return item;
  }

  @override
  Future<CareConversationItem> getConversation(
    String token,
    String conversationId,
  ) async {
    return CareConversationItem(
      id: conversationId,
      supportRequestId: 'req-1',
      userId: 1,
      specialistId: 'spec-1',
      status: 'open',
      specialist: specialists.first,
      messages: [
        const CareMessageItem(
          id: 'msg-1',
          conversationId: 'conv-1',
          senderId: 1,
          senderRole: 'member',
          body: 'How can I relieve cramps naturally?',
          isRead: true,
          createdAt: '2026-10-27T10:00:00Z',
        ),
      ],
    );
  }

  @override
  Future<CareMessageItem> sendMessage(
    String token,
    String conversationId,
    String body,
  ) async {
    return CareMessageItem(
      id: 'msg-2',
      conversationId: conversationId,
      senderId: 1,
      senderRole: 'member',
      body: body,
      isRead: false,
      createdAt: '2026-10-27T10:05:00Z',
    );
  }
}

void main() {
  testWidgets('Care tab displays verified specialists and allows interaction', (
    tester,
  ) async {
    final store = MemoryStore();
    final journalRepo = LocalJournalRepository(store, Api());
    final careRepo = FakeCareRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(journalRepo),
          careRepositoryProvider.overrideWithValue(careRepo),
          learningProvider.overrideWith((ref) async => []),
        ],
        child: const YanMataApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to Care tab
    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();

    expect(find.text('Room to ask.\nSomeone to listen.'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Dr. Fatima Bello'), 200);
    await tester.pumpAndSettle();

    expect(find.text('Dr. Fatima Bello'), findsOneWidget);
    expect(find.text('MBBS, FWACS (OB/GYN)'), findsOneWidget);
  });
}
