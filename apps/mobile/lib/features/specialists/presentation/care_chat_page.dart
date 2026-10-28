import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';

import '../application/care_providers.dart';

class CareChatPage extends ConsumerStatefulWidget {
  const CareChatPage({super.key, required this.conversationId});
  final String conversationId;

  @override
  ConsumerState<CareChatPage> createState() => _CareChatPageState();
}

class _CareChatPageState extends ConsumerState<CareChatPage> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.sendCareMessage(widget.conversationId, text);
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to send: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final convAsync = ref.watch(
      careConversationProvider(widget.conversationId),
    );

    return Scaffold(
      appBar: AppBar(
        title: convAsync.when(
          data: (conv) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                conv?.specialist?.name ?? 'Specialist Consultation',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              if (conv?.specialist?.credentials != null)
                Text(
                  conv!.specialist!.credentials,
                  style: const TextStyle(fontSize: 12, color: Palette.teal),
                ),
            ],
          ),
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Conversation'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Palette.blush,
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Palette.plum),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Asynchronous guidance · Jos pilot · Not an emergency service',
                      style: TextStyle(
                        fontSize: 11,
                        color: Palette.ink,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: convAsync.when(
                data: (conv) {
                  if (conv == null) {
                    return const Center(child: Text('Conversation not found.'));
                  }
                  final messages = conv.messages;
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet. Send a message to start.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderRole == 'member';
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Palette.plum : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: isMe
                                  ? const Radius.circular(18)
                                  : const Radius.circular(4),
                              bottomRight: isMe
                                  ? const Radius.circular(4)
                                  : const Radius.circular(18),
                            ),
                            border: isMe
                                ? null
                                : Border.all(color: const Color(0xFFE9E2E9)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Palette.teal,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        conv.specialist?.name ?? 'Specialist',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Palette.plum,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Text(
                                msg.body,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: isMe ? Colors.white : Palette.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Could not load messages: $e',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE9E2E9))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Type your question...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _isSending ? null : _send,
                    style: IconButton.styleFrom(backgroundColor: Palette.plum),
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
