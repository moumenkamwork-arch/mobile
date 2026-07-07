import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/promoo_button.dart';
import '../../../../shared/widgets/promoo_error_state.dart';
import '../../../../shared/widgets/promoo_image.dart';
import '../../../../shared/widgets/promoo_loading_indicator.dart';
import '../../../../shared/widgets/promoo_subpage_scaffold.dart';
import '../../../../shared/widgets/promoo_text_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/promoo_profile.dart';

/// Loads the demo profile used to prefill the Edit Profile form.
final editProfileSourceProvider = FutureProvider<PromooProfile>((ref) async {
  final result = await ref.watch(profileRepositoryProvider).getDemoProfile();
  return switch (result) {
    Success(data: final profile) => profile,
    Failure(failure: final failure) => throw Exception(failure.message),
  };
});

/// "Profile Management" screen recreating the original Edit Profile page:
/// avatar with change action, Name / Subtitle-Bio / Location / Category
/// fields, and the media grid with view counts.
///
/// Fields map 1:1 to backend `PUT /profiles/me` (`updateProfileSchema`:
/// full_name, bio, location, category_id). Phase A: local-only.
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(editProfileSourceProvider);

    return PromooSubpageScaffold(
      title: 'Edit Profile',
      child: profileAsync.when(
        loading: () => const Padding(
          padding: EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: Center(child: PromooLoadingIndicator()),
        ),
        error: (error, _) => PromooErrorState(
          title: 'Profile unavailable',
          message: 'Could not load your profile right now.',
          onRetry: () => ref.invalidate(editProfileSourceProvider),
        ),
        data: (profile) => _EditProfileForm(profile: profile),
      ),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm({required this.profile});

  final PromooProfile profile;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _locationController = TextEditingController(
      text: widget.profile.location ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryYellow,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: PromooImage(
                      imageUrl: profile.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 0,
                  end: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.brandBlack,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${profile.stats.followers} Followers',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  InkWell(
                    onTap: () => _showNotice(
                      'Changing the profile photo arrives with uploads in the next phase.',
                    ),
                    child: Text(
                      'Change profile photo',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryYellow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FieldCard(
          icon: Icons.person_outline_rounded,
          label: 'Name',
          child: PromooTextField(controller: _nameController),
        ),
        const SizedBox(height: AppSpacing.md),
        _FieldCard(
          icon: Icons.info_outline_rounded,
          label: 'Subtitle / Bio',
          child: PromooTextField(controller: _bioController),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FieldCard(
                icon: Icons.location_on_outlined,
                label: 'Location',
                child: PromooTextField(controller: _locationController),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _FieldCard(
                icon: Icons.category_outlined,
                label: 'Category',
                child: InkWell(
                  onTap: () => _showNotice(
                    'Category selection will be enabled in the next phase.',
                  ),
                  child: InputDecorator(
                    decoration: const InputDecoration(),
                    child: Text(
                      profile.categoryName ?? 'Select category',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Media', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.72,
          ),
          itemCount: profile.mediaUrls.length,
          itemBuilder: (context, index) {
            return _MediaTile(
              imageUrl: profile.mediaUrls[index],
              title: 'Post ${index + 1}',
              views: '${(index + 1) * 10}.4K',
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        PromooButton.primary(
          label: 'Save',
          fullWidth: true,
          onPressed: () => _showNotice(
            'Profile changes will sync with your account in the next phase.',
          ),
        ),
      ],
    );
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.imageUrl,
    required this.title,
    required this.views,
  });

  final String imageUrl;
  final String title;
  final String views;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.card,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PromooImage(imageUrl: imageUrl, fit: BoxFit.cover),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(views, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
