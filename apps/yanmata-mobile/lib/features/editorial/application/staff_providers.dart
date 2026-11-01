import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../journal/application/journal_controller.dart';
import '../data/staff_repository.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepository(ref.watch(apiProvider));
});

final staffContentProvider = FutureProvider.autoDispose<List<StaffContentItem>>(
  (ref) async {
    final journal = ref.watch(journalProvider).value;
    if (journal?.token == null || !journal!.isStaff) {
      return [];
    }
    final repo = ref.watch(staffRepositoryProvider);
    return repo.fetchStudioContent(journal.token!);
  },
);

final staffCareRequestsProvider =
    FutureProvider.autoDispose<List<StaffCareRequestItem>>((ref) async {
      final journal = ref.watch(journalProvider).value;
      if (journal?.token == null || !journal!.isStaff) {
        return [];
      }
      final repo = ref.watch(staffRepositoryProvider);
      return repo.fetchStudioCareRequests(journal.token!);
    });
