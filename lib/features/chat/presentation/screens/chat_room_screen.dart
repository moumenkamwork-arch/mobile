import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/chat_room_controller.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_message_input.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return _ChatRoomBody(roomId: roomId);
  }
}

class _ChatRoomBody extends ConsumerWidget {
  const _ChatRoomBody({required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatRoomControllerProvider(roomId));
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final inputBottomPadding = viewInsets.bottom > 0
        ? viewInsets.bottom + AppSpacing.lg
        : AppSpacing.md;

    return Scaffold(
      backgroundColor: context.colors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _ConversationHeader(onBack: () => _goBack(context)),
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    color: context.colors.accent,
                    backgroundColor: context.colors.elevatedSurface,
                    onRefresh: () => ref
                        .read(chatRoomControllerProvider(roomId).notifier)
                        .refresh(),
                    child: _ConversationBody(
                      state: state,
                      onRetry: () => ref
                          .read(chatRoomControllerProvider(roomId).notifier)
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
                child: Column(
                  children: [
                    if (state.sendFailure != null) ...[
                      _SendFailureBanner(message: state.sendFailure!.message),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    ChatMessageInput(
                      isSending: state.isSending,
                      onSend: (text) => ref
                          .read(chatRoomControllerProvider(roomId).notifier)
                          .sendText(text),
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

class _ConversationHeader extends StatelessWidget {
  const _ConversationHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: AppLocalizations.of(context).commonBack,
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              AppLocalizations.of(context).chatConversationTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
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
      ChatRoomStatus.refreshing ||
      ChatRoomStatus.sending => ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screenHorizontal,
          AppSpacing.md,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        itemCount: state.messages.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          return ChatMessageBubble(message: state.messages[index]);
        },
      ),
    };
  }
}

class _SendFailureBanner extends StatelessWidget {
  const _SendFailureBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.elevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.error),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

bool _canShowInput(ChatRoomState state) {
  return switch (state.status) {
    ChatRoomStatus.success ||
    ChatRoomStatus.empty ||
    ChatRoomStatus.sending => true,
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
