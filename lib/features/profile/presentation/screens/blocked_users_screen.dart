import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/promoo_avatar_circle.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/follow_user.dart';
import '../controllers/blocked_users_controller.dart';

/// "Blocked Users" management page: `GET /blocks` + unblock
/// (`DELETE /blocks/:id`, optimistic + revert) — the counterpart to blocking
/// someone from their public profile.
class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        blockedUsersControllerProvider.overrideWith(BlockedUsersController.new),
      ],
      child: const _BlockedUsersScreenBody(),
    );
  }
}

class _BlockedUsersScreenBody extends ConsumerWidget {
  const _BlockedUsersScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(blockedUsersControllerProvider);

    return PromooSubpageScaffold(
      title: l10n.menuBlockedUsers,
      child: switch (state.status) {
        BlockedUsersStatus.loading => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooLoadingIndicator(message: l10n.menuBlockedUsers),
        ),
        BlockedUsersStatus.error => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooErrorState(
            title: l10n.commonSomethingWentWrong,
            message: state.failure?.message ?? l10n.commonSomethingWentWrong,
            onRetry: () =>
                ref.read(blockedUsersControllerProvider.notifier).retry(),
          ),
        ),
        BlockedUsersStatus.empty => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooEmptyState(
            title: l10n.blockedUsersEmptyTitle,
            message: l10n.blockedUsersEmptyMessage,
          ),
        ),
        BlockedUsersStatus.success => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final user in state.users) ...[
              _BlockedUserRow(
                user: user,
                onUnblock: () => ref
                    .read(blockedUsersControllerProvider.notifier)
                    .unblock(user.id),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      },
    );
  }
}

class _BlockedUserRow extends StatelessWidget {
  const _BlockedUserRow({required this.user, required this.onUnblock});

  final FollowUser user;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Row(
          children: [
            PromooAvatarCircle(
              imageUrl: user.avatarUrl,
              semanticLabel: user.name,
              size: 52,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                user.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            OutlinedButton(
              onPressed: onUnblock,
              child: Text(AppLocalizations.of(context).profileUnblockAction),
            ),
          ],
        ),
      ),
    );
  }
}
