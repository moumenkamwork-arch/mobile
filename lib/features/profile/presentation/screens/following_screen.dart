import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_avatar_circle.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/follow_user.dart';
import '../controllers/following_controller.dart';

/// "Following" page: the accounts the signed-in user follows, from
/// `GET /follows/following/:myId`. Wired in Phase 7 (list) / the auth-header fix.
/// Tapping a row opens that profile; the button unfollows (real
/// `DELETE /follows/:id`, optimistic + revert).
class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fresh ProviderScope per visit — `followingControllerProvider` is a
    // root-scoped Notifier that only loads once (in `build()`); without this,
    // re-opening the page after following/unfollowing someone elsewhere shows
    // stale cached data instead of the real current list (same pattern as
    // ProfileScreen re-creating profileControllerProvider per visit).
    return ProviderScope(
      overrides: [
        followingControllerProvider.overrideWith(FollowingController.new),
      ],
      child: const _FollowingScreenBody(),
    );
  }
}

class _FollowingScreenBody extends ConsumerWidget {
  const _FollowingScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(followingControllerProvider);

    return PromooSubpageScaffold(
      title: l10n.menuFollowing,
      child: switch (state.status) {
        FollowingStatus.loading => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooLoadingIndicator(message: l10n.menuFollowing),
        ),
        FollowingStatus.error => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooErrorState(
            title: l10n.commonSomethingWentWrong,
            message: state.failure?.message ?? l10n.commonSomethingWentWrong,
            onRetry: () =>
                ref.read(followingControllerProvider.notifier).retry(),
          ),
        ),
        FollowingStatus.empty => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooEmptyState(
            title: l10n.profileFollowingEmptyTitle,
            message: l10n.profileFollowingEmptyMessage,
          ),
        ),
        FollowingStatus.success => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final user in state.users) ...[
              _FollowingRow(
                user: user,
                onOpenProfile: () =>
                    context.push(AppRoutes.profileById(user.username ?? user.id)),
                onUnfollow: () => ref
                    .read(followingControllerProvider.notifier)
                    .unfollow(user.id),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      },
    );
  }
}

class _FollowingRow extends StatelessWidget {
  const _FollowingRow({
    required this.user,
    required this.onOpenProfile,
    required this.onUnfollow,
  });

  final FollowUser user;
  final VoidCallback onOpenProfile;
  final VoidCallback onUnfollow;

  String _typeLabel(String? raw) {
    return switch (raw) {
      'company' => 'Company',
      'influencer' => 'Influencer',
      'service_provider' => 'Service Provider',
      'user' => 'User',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = _typeLabel(user.accountType);

    return PromooCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onOpenProfile,
        borderRadius: BorderRadius.circular(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (type.isNotEmpty)
                      Text(
                        type,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.accent,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              OutlinedButton(
                onPressed: onUnfollow,
                child: Text(AppLocalizations.of(context).profileActionFollowing),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
