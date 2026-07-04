import 'package:flutter/material.dart';

import '../../../../shared/widgets/promoo_card.dart';
import '../../../../shared/widgets/promoo_image.dart';
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
                if (profile.bio != null && profile.bio!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profile.bio!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
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

    return ClipRRect(
      borderRadius: const BorderRadiusDirectional.vertical(
        top: Radius.circular(AppRadius.lg),
      ),
      child: Container(
        height: 108,
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.surface),
        child: Stack(
          children: [
            Positioned.fill(
              child: PromooImage(
                imageUrl: coverUrl,
                fallbackIcon: Icons.workspace_premium_rounded,
                semanticLabel: '${profile.displayName} cover',
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.brandBlack.withValues(alpha: 0.42),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final PromooProfile profile;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.brandBlack,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryYellow, width: 2),
      ),
      child: ClipOval(
        child: avatarUrl == null
            ? Center(
                child: Text(
                  _initialsFor(profile.displayName),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryYellow,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : PromooImage(
                imageUrl: avatarUrl,
                fallbackIcon: Icons.person_rounded,
                semanticLabel: profile.displayName,
              ),
      ),
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
