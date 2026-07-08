import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_empty_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';

/// "Following" page: accounts the user follows.
///
/// Phase A shows demo follows (fictional Promoo demo identities) with a
/// local unfollow toggle; the integration phase swaps this to backend
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
  final _following = <_FollowedProfile>[
    const _FollowedProfile(
      id: 'profile-saffron-social',
      name: 'Saffron Social Studio',
      type: 'Company',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
    ),
    const _FollowedProfile(
      id: 'profile-sara-fashion',
      name: 'Sara Fashion',
      type: 'Influencer',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
    ),
    const _FollowedProfile(
      id: 'profile-hadi-coding',
      name: 'Hadi Coding',
      type: 'Influencer',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    const _FollowedProfile(
      id: 'profile-maysa-cooking',
      name: 'Maysa Cooking',
      type: 'Influencer',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PromooSubpageScaffold(
      title: 'Following',
      child: _following.isEmpty
          ? const Padding(
              padding: EdgeInsetsDirectional.only(top: AppSpacing.xxl),
              child: PromooEmptyState(
                title: 'No follows yet',
                message: 'Profiles you follow will appear here.',
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final profile in _following) ...[
                  PromooCard(
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: context.colors.accent),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _following.removeWhere(
                                (it) => it.id == profile.id,
                              );
                            });
                          },
                          child: const Text('Following'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
    );
  }
}
