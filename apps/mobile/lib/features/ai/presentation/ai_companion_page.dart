import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/theme.dart';
import '../application/ai_companion_provider.dart';
import '../domain/ai_companion_model.dart';

class AiCompanionPage extends ConsumerStatefulWidget {
  const AiCompanionPage({super.key});

  @override
  ConsumerState<AiCompanionPage> createState() => _AiCompanionPageState();
}

class _AiCompanionPageState extends ConsumerState<AiCompanionPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? text]) {
    final prompt = text ?? _controller.text;
    if (prompt.trim().isEmpty) return;
    ref.read(aiChatProvider.notifier).sendUserPrompt(prompt);
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final activeLang = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Palette.plum, Palette.lilac],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Center(
                child: Text('✨', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Aisha AI',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Palette.darkText : Palette.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Color(0xFF10B981), size: 6),
                          SizedBox(width: 4),
                          Text(
                            '24/7 PRIVATE',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${activeLang.nativeName} · Educational Companion',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Palette.darkMuted : Palette.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Clear conversation',
            onPressed: () =>
                ref.read(aiChatProvider.notifier).clearConversation(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Safety Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark
                ? Palette.plum.withValues(alpha: 0.3)
                : Palette.blush.withValues(alpha: 0.4),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 16,
                  color: Palette.plum,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ref.tr('ai_disclaimer'),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Palette.darkMuted
                          : Palette.ink.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount:
                  chatState.messages.length + (chatState.isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chatState.messages.length &&
                    chatState.isThinking) {
                  return _buildThinkingBubble(isDark);
                }
                final msg = chatState.messages[index];
                return _buildMessageItem(msg, isDark);
              },
            ),
          ),

          // Error Message if any
          if (chatState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                chatState.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          // Quick Suggested Prompts
          _buildQuickPromptsBar(isDark),

          // Input Row
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageItem(AiMessage msg, bool isDark) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Palette.plum,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (msg.isEmergency) _buildEmergencyNotice(msg, isDark),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12, right: 36),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? Palette.darkCard : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color: isDark ? Palette.darkBorder : const Color(0xFFEFE6F1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.text,
                  style: TextStyle(
                    color: isDark ? Palette.darkText : Palette.ink,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                ),
                if (msg.citations.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Text(
                    'Sources: ${msg.citations.first}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Palette.darkMuted : Palette.muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (msg.followUps.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: msg.followUps.map((q) {
                return ActionChip(
                  label: Text(q, style: const TextStyle(fontSize: 12)),
                  backgroundColor: isDark
                      ? Palette.darkSurface
                      : Palette.lilac.withValues(alpha: 0.4),
                  side: BorderSide(color: Palette.lilac.withValues(alpha: 0.5)),
                  onPressed: () => _sendMessage(q),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmergencyNotice(AiMessage msg, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF43F5E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFE11D48)),
              SizedBox(width: 8),
              Text(
                'EMERGENCY CRISIS SUPPORT',
                style: TextStyle(
                  color: Color(0xFF9F1239),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...msg.helplines.map((h) {
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• ${h['name']}: ${h['number']} (${h['cost']})',
                style: const TextStyle(
                  color: Color(0xFF881337),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildThinkingBubble(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Palette.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Palette.plum,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Aisha is thinking…',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Palette.darkMuted : Palette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPromptsBar(bool isDark) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildPromptChip(ref.tr('ai_quick_prompt_1'), isDark),
          const SizedBox(width: 8),
          _buildPromptChip(ref.tr('ai_quick_prompt_2'), isDark),
          const SizedBox(width: 8),
          _buildPromptChip(ref.tr('ai_quick_prompt_3'), isDark),
          const SizedBox(width: 8),
          _buildPromptChip(ref.tr('ai_quick_prompt_4'), isDark),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text, bool isDark) {
    return InkWell(
      onTap: () => _sendMessage(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Palette.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Palette.darkBorder : const Color(0xFFE8DEF8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Palette.darkText : Palette.ink,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Palette.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Palette.darkBorder : const Color(0xFFEBE3EC),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(
                  color: isDark ? Palette.darkText : Palette.ink,
                  fontSize: 14.5,
                ),
                decoration: InputDecoration(
                  hintText: ref.tr('ai_input_placeholder'),
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? Palette.darkMuted : Palette.muted,
                  ),
                  filled: true,
                  fillColor: isDark ? Palette.darkCard : Palette.cream,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Palette.plum,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                ),
                onPressed: () => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
