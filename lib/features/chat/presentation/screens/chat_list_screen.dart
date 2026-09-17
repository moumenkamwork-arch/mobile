import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_list_header.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_room_card.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatControllerProvider);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: colors.accent,
              backgroundColor: colors.elevatedSurface,
              onRefresh: () =>
                  ref.read(chatControllerProvider.notifier).refresh(),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.lg,
                      AppSpacing.screenHorizontal,
                      AppSpacing.xxl,
                    ),
                    sliver: SliverList.list(
                      children: [
                        _ChatHeader(
                          onBack: () => _goBack(context),
                          // Push keeps the stack so back returns to chats.
                          onNotifications: () =>
                              context.push(AppRoutes.notifications),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _ChatBody(
                          state: state,
                          onRetry: () =>
                              ref.read(chatControllerProvider.notifier).retry(),
                          onLogin: () => context.push(AppRoutes.login),
                          onRoomSelected: (roomId) =>
                              context.push(AppRoutes.chatRoom(roomId)),
                        ),
                      ],
                    ),
                  ),
                ],
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
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.onBack, required this.onNotifications});

  final VoidCallback onBack;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooListHeader(
      title: l10n.headerChats,
      subtitle: l10n.chatListSubtitle,
      onBack: onBack,
      trailing: IconButton(
        tooltip: l10n.headerNotifications,
        onPressed: onNotifications,
        icon: const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.state,
    required this.onRetry,
    required this.onLogin,
    required this.onRoomSelected,
  });

  final ChatState state;
  final VoidCallback onRetry;
  final VoidCallback onLogin;
  final ValueChanged<String> onRoomSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (state.status) {
      ChatStatus.loading => SizedBox(
        height: 420,
        child: PromooLoadingIndicator(message: l10n.chatLoadingMessage),
      ),
      ChatStatus.empty => SizedBox(
        height: 420,
        child: PromooEmptyState(
          title: l10n.chatEmptyTitle,
          message: l10n.chatEmptyMessage,
          icon: Icons.chat_bubble_outline_rounded,
        ),
      ),
      ChatStatus.error =>
        state.isAuthRequired
            ? SizedBox(
                height: 420,
                child: _AuthRequiredState(
                  message: state.failure?.message,
                  onLogin: onLogin,
                ),
              )
            : SizedBox(
                height: 420,
                child: PromooErrorState(
                  title: l10n.chatErrorTitle,
                  message:
                      state.failure?.message ??
                      l10n.commonSomethingWentWrongShort,
                  onRetry: onRetry,
                ),
              ),
      ChatStatus.success || ChatStatus.refreshing => Column(
        children: [
          for (var i = 0; i < state.rooms.length; i++) ...[
            ChatRoomCard(
              room: state.rooms[i],
              onTap: () => onRoomSelected(state.rooms[i].id),
            ),
            if (i != state.rooms.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    };
  }
}

class _AuthRequiredState extends StatelessWidget {
  const _AuthRequiredState({required this.onLogin, this.message});

  final VoidCallback onLogin;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooEmptyState(
      title: l10n.commonLoginRequiredTitle,
      message: message ?? l10n.chatAuthRequiredMessage,
      icon: Icons.lock_outline_rounded,
      actionLabel: l10n.commonGoToLogin,
      onActionPressed: onLogin,
    );
  }
}

void _goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}
