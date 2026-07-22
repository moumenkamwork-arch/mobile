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
import '../controllers/followers_controller.dart';

/// "Followers" page: accounts following the signed-in user, from
/// `GET /follows/followers/:myId`. Tapping a row opens that profile.
class FollowersScreen extends StatelessWidget {
  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fresh ProviderScope per visit — same reasoning as FollowingScreen
    // (root-scoped Notifier that only loads once in `build()`).
    return ProviderScope(
      overrides: [
        followersControllerProvider.overrideWith(FollowersController.new),
      ],
      child: const _FollowersScreenBody(),
    );
  }
}

class _FollowersScreenBody extends ConsumerWidget {
  const _FollowersScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(followersControllerProvider);

    return PromooSubpageScaffold(
      title: l10n.menuFollowers,
      child: switch (state.status) {
        FollowersStatus.loading => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooLoadingIndicator(message: l10n.menuFollowers),
        ),
        FollowersStatus.error => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooErrorState(
            title: l10n.commonSomethingWentWrong,
            message: state.failure?.message ?? l10n.commonSomethingWentWrong,
            onRetry: () =>
                ref.read(followersControllerProvider.notifier).retry(),
          ),
        ),
        FollowersStatus.empty => Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: PromooEmptyState(
            title: l10n.profileFollowersEmptyTitle,
            message: l10n.profileFollowersEmptyMessage,
          ),
        ),
        FollowersStatus.success => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final user in state.users) ...[
              _FollowerRow(
                user: user,
                onOpenProfile: () =>
                    context.push(AppRoutes.profileById(user.username ?? user.id)),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      },
    );
  }
}

class _FollowerRow extends StatelessWidget {
  const _FollowerRow({required this.user, required this.onOpenProfile});

  final FollowUser user;
  final VoidCallback onOpenProfile;

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
            ],
          ),
        ),
      ),
    );
  }
}
