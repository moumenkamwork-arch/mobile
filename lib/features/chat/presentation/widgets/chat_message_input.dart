import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_spacing.dart';

class ChatMessageInput extends StatefulWidget {
  const ChatMessageInput({
    super.key,
    required this.onSend,
    this.enabled = true,
    this.isSending = false,
  });

  final ValueChanged<String> onSend;
  final bool enabled;
  final bool isSending;

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: PromooTextField(
            controller: _controller,
            label: l10n.profileActionMessage,
            hint: l10n.chatWriteMessageHint,
            enabled: widget.enabled && !widget.isSending,
            textInputAction: TextInputAction.send,
            prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
            onSubmitted: (_) => _send(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PromooButton.primary(
          label: widget.isSending
              ? l10n.chatSendingButton
              : l10n.chatSendButton,
          icon: Icons.send_rounded,
          onPressed: widget.enabled && !widget.isSending ? _send : null,
        ),
      ],
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    widget.onSend(text);
    _controller.clear();
  }
}
