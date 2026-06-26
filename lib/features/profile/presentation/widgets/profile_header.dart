import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../domain/entities/promoo_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final PromooProfile profile;

  @override
  Widget build(BuildContext context) {
    return PromooCard(
      elevated: true,
      borderColor: profile.isVerified
          ? AppColors.primaryYellow
          : AppColors.border,
      color: AppColors.elevatedSurface,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Cover(profile: profile),
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Avatar(profile: profile),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  profile.displayName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              if (profile.isVerified) ...[
                                const SizedBox(width: AppSpacing.xs),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.primaryYellow,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            profile.handle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _MetaChip(label: profile.accountType.label),
                    if (profile.categoryName != null)
                      _MetaChip(label: profile.categoryName!),
                    if (profile.location != null)
                      _MetaChip(label: profile.location!),
                    if (profile.isFeatured) const _MetaChip(label: 'Featured'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.profile});

  final PromooProfile profile;

  @override
  Widget build(BuildContext context) {
    final coverUrl = profile.coverUrl;

    return Container(
      height: 108,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadiusDirectional.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
        image: coverUrl == null
            ? null
            : DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover),
      ),
      child: coverUrl == null
          ? Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primaryYellow.withValues(alpha: 0.9),
                  size: 42,
                ),
              ),
            )
          : null,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final PromooProfile profile;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;

    return CircleAvatar(
      radius: 32,
      backgroundColor: AppColors.brandBlack,
      backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
      child: avatarUrl == null
          ? Text(
              _initialsFor(profile.displayName),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryYellow,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

String _initialsFor(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return 'P';
  }
  if (parts.length == 1) {
    return _firstCharacter(parts.first).toUpperCase();
  }
  return '${_firstCharacter(parts.first)}${_firstCharacter(parts.last)}'
      .toUpperCase();
}

String _firstCharacter(String value) {
  return String.fromCharCode(value.runes.first);
}
