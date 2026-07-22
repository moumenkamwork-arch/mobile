import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_detail_header.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../profile/data/repositories/profile_repository_impl.dart';
import '../../../reports/domain/entities/report_draft.dart';
import '../../../reports/presentation/report_sheet.dart';
import '../../domain/entities/chat.dart';
import '../controllers/chat_room_controller.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_message_input.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key, required String roomId})
    : arg = (roomId: roomId, participantId: null);

  /// No room exists yet — [ChatRoomController] resolves (or creates) one via
  /// `startChat` in the background while this shows an immediately-usable
  /// empty conversation, instead of the caller waiting on that network call
  /// before navigating at all.
  const ChatRoomScreen.newChat({super.key, required String participantId})
    : arg = (roomId: null, participantId: participantId);

  final ChatRoomArg arg;

  @override
  Widget build(BuildContext context) {
    return _ChatRoomBody(arg: arg);
  }
}

class _ChatRoomBody extends ConsumerWidget {
  const _ChatRoomBody({required this.arg});

  final ChatRoomArg arg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatRoomControllerProvider(arg));
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final inputBottomPadding = viewInsets.bottom > 0
        ? viewInsets.bottom + AppSpacing.lg
        : AppSpacing.md;

    // The other person's id, for the Block/Report menu — from the participant
    // we opened with, or (for a room opened by id) the sender of any message
    // that isn't ours.
    String? otherParticipantId = arg.participantId;
    if (otherParticipantId == null || otherParticipantId.isEmpty) {
      for (final message in state.messages) {
        if (!message.isMine && message.senderId.isNotEmpty) {
          otherParticipantId = message.senderId;
          break;
        }
      }
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _ConversationHeader(
              onBack: () => _goBack(context),
              otherParticipantId: otherParticipantId,
            ),
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    color: context.colors.accent,
                    backgroundColor: context.colors.elevatedSurface,
                    onRefresh: () => ref
                        .read(chatRoomControllerProvider(arg).notifier)
                        .refresh(),
                    child: _ConversationBody(
                      state: state,
                      onRetry: () => ref
                          .read(chatRoomControllerProvider(arg).notifier)
                          .retry(),
                      onLogin: () => context.go(AppRoutes.login),
                    ),
                  ),
                  if (state.isRefreshing)
                    const PositionedDirectional(
                      top: 0,
                      start: 0,
                      end: 0,
                      child: LinearProgressIndicator(minHeight: 2),
                    ),
                ],
              ),
            ),
            if (_canShowInput(state))
              AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.sm,
                  AppSpacing.screenHorizontal,
                  inputBottomPadding,
                ),
                child: ChatMessageInput(
                  onSend: (text) => ref
                      .read(chatRoomControllerProvider(arg).notifier)
                      .sendText(text),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConversationHeader extends StatelessWidget {
  const _ConversationHeader({required this.onBack, this.otherParticipantId});

  final VoidCallback onBack;
  final String? otherParticipantId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
      ),
      child: PromooDetailHeader(
        title: AppLocalizations.of(context).chatConversationTitle,
        onBack: onBack,
        trailing: otherParticipantId == null
            ? null
            : _ChatRoomMenuButton(participantId: otherParticipantId!),
      ),
    );
  }
}

enum _ChatMenuAction { block, report }

/// Instagram-style "⋮" in the chat header: block or report the person you're
/// talking to. Block calls `POST /blocks/:id` directly (with a confirm), which
/// also stops further messages both ways server-side (`chat.service.ts`).
class _ChatRoomMenuButton extends ConsumerWidget {
  const _ChatRoomMenuButton({required this.participantId});

  final String participantId;

  Future<void> _block(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
        title: Text(l10n.profileBlockConfirmTitle),
        content: Text(l10n.profileBlockConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.profileBlockConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final result = await ref
        .read(profileRepositoryProvider)
        .blockProfile(participantId);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            result.isSuccess
                ? l10n.profileBlockedSnackbar
                : l10n.commonSomethingWentWrong,
          ),
        ),
      );
    if (result.isSuccess && context.mounted) {
      // Blocking ends the conversation — leave the room.
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_ChatMenuAction>(
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) {
        switch (action) {
          case _ChatMenuAction.block:
            _block(context, ref);
          case _ChatMenuAction.report:
            showReportSheet(
              context,
              ref,
              reportedId: participantId,
              reportedType: ReportedType.profile,
            );
        }
      },
      itemBuilder: (menuContext) => [
        PopupMenuItem<_ChatMenuAction>(
          value: _ChatMenuAction.block,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.block_rounded, color: Colors.redAccent),
            title: Text(
              l10n.profileBlockAction,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
        PopupMenuItem<_ChatMenuAction>(
          value: _ChatMenuAction.report,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.flag_outlined),
            title: Text(l10n.reportAction),
          ),
        ),
      ],
    );
  }
}

class _ConversationBody extends StatelessWidget {
  const _ConversationBody({
    required this.state,
    required this.onRetry,
    required this.onLogin,
  });

  final ChatRoomState state;
  final VoidCallback onRetry;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (state.status) {
      ChatRoomStatus.loading => PromooLoadingIndicator(
        message: l10n.chatRoomLoadingMessage,
      ),
      ChatRoomStatus.empty => CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: PromooEmptyState(
              title: l10n.chatNoMessagesYet,
              message: l10n.chatRoomEmptyMessage,
              icon: Icons.chat_bubble_outline_rounded,
            ),
          ),
        ],
      ),
      ChatRoomStatus.error =>
        state.isAuthRequired
            ? CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: PromooEmptyState(
                      title: l10n.commonLoginRequiredTitle,
                      message:
                          state.failure?.message ??
                          l10n.chatRoomAuthRequiredMessage,
                      icon: Icons.lock_outline_rounded,
                      actionLabel: l10n.commonGoToLogin,
                      onActionPressed: onLogin,
                    ),
                  ),
                ],
              )
            : PromooErrorState(
                title: l10n.chatRoomErrorTitle,
                message:
                    state.failure?.message ??
                    l10n.commonSomethingWentWrongShort,
                onRetry: onRetry,
              ),
      ChatRoomStatus.success ||
      ChatRoomStatus.refreshing => _MessageList(messages: state.messages),
    };
  }
}

/// Message list that opens pinned to the LATEST message and follows new ones.
/// Messages are stored oldest→newest, so "latest" is the bottom — on first
/// build and whenever the count grows (load / send / realtime) it jumps (or
/// animates) to `maxScrollExtent` after layout.
class _MessageList extends StatefulWidget {
  const _MessageList({required this.messages});

  final List<ChatMessage> messages;

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // First open: jump straight to the bottom (no animation) so the user
    // starts on the newest message, not the top of the history.
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToBottom());
  }

  @override
  void didUpdateWidget(_MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _animateToBottom());
    }
  }

  void _jumpToBottom() {
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }
  }

  void _animateToBottom() {
    if (_controller.hasClients) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screenHorizontal,
        AppSpacing.md,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      itemCount: widget.messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return ChatMessageBubble(message: widget.messages[index]);
      },
    );
  }
}

bool _canShowInput(ChatRoomState state) {
  return switch (state.status) {
    ChatRoomStatus.success || ChatRoomStatus.empty => true,
    ChatRoomStatus.loading ||
    ChatRoomStatus.error ||
    ChatRoomStatus.refreshing => state.hasContent,
  };
}

void _goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.chats);
  }
}
