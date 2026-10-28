import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/providers.dart';
import '../data/ai_repository.dart';
import '../domain/ai_companion_model.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return AiRepository(baseUrl: baseUrl);
});

class AiChatState {
  final List<AiMessage> messages;
  final bool isThinking;
  final String? errorMessage;

  const AiChatState({
    required this.messages,
    this.isThinking = false,
    this.errorMessage,
  });

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? isThinking,
    String? errorMessage,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
      errorMessage: errorMessage,
    );
  }
}

class AiChatNotifier extends Notifier<AiChatState> {
  @override
  AiChatState build() {
    final lang = ref.watch(localeProvider);
    final initialGreeting = _getInitialGreeting(lang);

    return AiChatState(
      messages: [
        AiMessage(
          id: 'welcome',
          text: initialGreeting,
          isUser: false,
          timestamp: DateTime.now(),
          followUps: [
            ref.watch(localeProvider) == AppLanguage.hausa
                ? 'Shin hailata tana tafiya dai-dai?'
                : 'Is my cycle rhythm normal?',
            ref.watch(localeProvider) == AppLanguage.hausa
                ? 'Yaya zan rage ciwon marar haila?'
                : 'How can I soothe period cramps?',
            ref.watch(localeProvider) == AppLanguage.hausa
                ? 'Menene lokacin follicular?'
                : 'What is the follicular phase?',
          ],
        ),
      ],
    );
  }

  String _getInitialGreeting(AppLanguage lang) {
    return switch (lang) {
      AppLanguage.hausa => 'Barka da zuwa! Ni ce Aisha, mataimakiyarki ta ilimin lafiya. Kina iya tambayata komai game da hailarki, canjin jiki, ko yanayin zuciya cikin cikakken sirri.',
      AppLanguage.yoruba => 'Ẹ kú àbọ̀! Èmi ni Aisha, olùrànlọ́wọ́ ilera rẹ. O lè béèrè ohunkóhun lọ́wọ́ mi nípa nǹkan oṣù rẹ, ara rẹ, tàbí àlàáfíà ọkàn rẹ pẹ̀lú àṣírí pípé.',
      AppLanguage.igbo => 'Nnọọ! Abụ m Aisha, onye enyemaka ahụike gị. Ị nwere ike ịjụ m ajụjụ ọ bụla banyere oge nsọ gị, mgbanwe ahụ gị, ma ọ bụ obi gị na nzuzo zuru oke.',
      AppLanguage.pidgin => 'Welcome! I be Aisha, your personal health buddy. Feel free to ask me anything about your period, cramps, or body changes without fear. Na pure secret level.',
      AppLanguage.english => 'Hello! I am Aisha, your personal health and cycle companion. You can ask me sensitive questions about your body rhythm, symptoms, or emotional changes in complete privacy.',
    };
  }

  Future<void> sendUserPrompt(String prompt) async {
    final cleanPrompt = prompt.trim();
    if (cleanPrompt.isEmpty) return;

    final userMsg = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: cleanPrompt,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isThinking: true,
      errorMessage: null,
    );

    try {
      final repo = ref.read(aiRepositoryProvider);
      final lang = ref.read(localeProvider);

      final reply = await repo.sendMessage(
        prompt: cleanPrompt,
        language: lang.code,
      );

      state = state.copyWith(
        messages: [...state.messages, reply],
        isThinking: false,
      );
    } catch (e) {
      state = state.copyWith(
        isThinking: false,
        errorMessage: 'Unable to reach Aisha right now. Please check your connection and try again.',
      );
    }
  }

  void clearConversation() {
    final lang = ref.read(localeProvider);
    state = AiChatState(
      messages: [
        AiMessage(
          id: 'welcome_reset',
          text: _getInitialGreeting(lang),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }
}

final aiChatProvider = NotifierProvider<AiChatNotifier, AiChatState>(
  AiChatNotifier.new,
);
