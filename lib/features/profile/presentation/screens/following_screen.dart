import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// "Following" page: accounts the user follows.
///
/// Phase A shows demo follows (fictional Promoo demo identities). Tapping a
/// row opens that profile; the "Following" button toggles to "Follow" like
/// Instagram (kept locally). The integration phase swaps this to backend
/// `GET /profiles/:id/following` + `/follows` mutations.
class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowedProfile {
  const _FollowedProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String type;
  final String avatarUrl;
}

class _FollowingScreenState extends State<FollowingScreen> {
  static const _following = <_FollowedProfile>[
    _FollowedProfile(
      id: 'profile-saffron-social',
      name: 'Saffron Social Studio',
      type: 'Company',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
    ),
    _FollowedProfile(
      id: 'profile-sara-fashion',
      name: 'Sara Fashion',
      type: 'Influencer',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
    ),
    _FollowedProfile(
      id: 'profile-hadi-coding',
      name: 'Hadi Coding',
      type: 'Influencer',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    _FollowedProfile(
      id: 'profile-maysa-cooking',
      name: 'Maysa Cooking',
      type: 'Influencer',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
    ),
  ];

  /// Ids the user has toggled to "unfollowed". Kept in-memory (like Instagram,
  /// the row stays visible so it can be re-followed until the page reloads).
  final _unfollowed = <String>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PromooSubpageScaffold(
      title: l10n.menuFollowing,
      child: _following.isEmpty
          ? Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl),
              child: PromooEmptyState(
                title: l10n.profileFollowingEmptyTitle,
                message: l10n.profileFollowingEmptyMessage,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final profile in _following) ...[
                  _FollowingRow(
                    profile: profile,
                    isFollowing: !_unfollowed.contains(profile.id),
                    onOpenProfile: () =>
                        context.push(AppRoutes.profileById(profile.id)),
                    onToggleFollow: () {
                      setState(() {
                        if (_unfollowed.contains(profile.id)) {
                          _unfollowed.remove(profile.id);
                        } else {
                          _unfollowed.add(profile.id);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
    );
  }
}

class _FollowingRow extends StatelessWidget {
  const _FollowingRow({
    required this.profile,
    required this.isFollowing,
    required this.onOpenProfile,
    required this.onToggleFollow,
  });

  final _FollowedProfile profile;
  final bool isFollowing;
  final VoidCallback onOpenProfile;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PromooCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onOpenProfile,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
          child: Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: PromooImage(
                    imageUrl: profile.avatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      profile.type,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Instagram-style: "Following" (outlined) toggles to "Follow"
              // (filled) without leaving the list.
              isFollowing
                  ? OutlinedButton(
                      onPressed: onToggleFollow,
                      child: Text(
                        AppLocalizations.of(context).profileActionFollowing,
                      ),
                    )
                  : FilledButton(
                      onPressed: onToggleFollow,
                      child: Text(
                        AppLocalizations.of(context).profileActionFollow,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
