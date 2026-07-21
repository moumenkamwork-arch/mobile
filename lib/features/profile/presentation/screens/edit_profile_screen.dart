import 'package:promoo_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/result.dart';
import '../../../upload/data/repositories/upload_repository_impl.dart';
import '../../../upload/domain/entities/uploaded_media.dart';
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
import '../controllers/profile_controller.dart';
import '../widgets/profile_media_section.dart';

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
/// full_name, bio, location, category_id) — Name/Bio/Location save for real;
/// avatar/category stay "coming soon" until Upload (Phase 9) wires them.
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(editProfileSourceProvider);
    final l10n = AppLocalizations.of(context);

    return PromooSubpageScaffold(
      title: l10n.profileEditScreenTitle,
      child: profileAsync.when(
        loading: () => const Padding(
          padding: EdgeInsetsDirectional.only(top: AppSpacing.xxl),
          child: Center(child: PromooLoadingIndicator()),
        ),
        error: (error, _) => PromooErrorState(
          title: l10n.profileEditUnavailableTitle,
          message: l10n.profileEditUnavailableMessage,
          onRetry: () => ref.invalidate(editProfileSourceProvider),
        ),
        data: (profile) => _EditProfileForm(profile: profile),
      ),
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  const _EditProfileForm({required this.profile});

  final PromooProfile profile;

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isSaving = false;
  bool _isUploadingAvatar = false;

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
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _isUploadingAvatar
                  ? null
                  : () => _pickAndUploadAvatar(l10n),
              child: Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    // Brand ring around the photo — yellow in both themes.
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.brandYellow, width: 3),
                    ),
                    child: ClipOval(
                      child: PromooImage(
                        imageUrl: profile.avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Dim the photo behind a spinner while the pick → upload →
                  // POST /profiles/me/avatar round-trip is in flight.
                  if (_isUploadingAvatar)
                    Positioned.fill(
                      child: ClipOval(
                        child: ColoredBox(
                          color: AppColors.brandBlack.withValues(alpha: 0.55),
                          child: const Center(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.brandYellow,
                              ),
                            ),
                          ),
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
                        color: AppColors.brandYellow,
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
                    l10n.leaderboardFollowersCount(profile.stats.followers),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  InkWell(
                    onTap: _isUploadingAvatar
                        ? null
                        : () => _pickAndUploadAvatar(l10n),
                    child: Text(
                      _isUploadingAvatar
                          ? l10n.profileEditUploadingPhoto
                          : l10n.profileEditChangePhoto,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.colors.accent,
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
          label: l10n.profileEditFieldName,
          child: PromooTextField(controller: _nameController),
        ),
        const SizedBox(height: AppSpacing.md),
        _FieldCard(
          icon: Icons.info_outline_rounded,
          label: l10n.profileEditFieldBio,
          child: PromooTextField(controller: _bioController),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FieldCard(
                icon: Icons.location_on_outlined,
                label: l10n.profileEditFieldLocation,
                child: PromooTextField(controller: _locationController),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _FieldCard(
                icon: Icons.category_outlined,
                label: l10n.profileEditFieldCategory,
                child: InkWell(
                  onTap: () => _showNotice(l10n.profileEditCategoryComingSoon),
                  child: InputDecorator(
                    decoration: const InputDecoration(),
                    child: Text(
                      profile.categoryName ?? l10n.commonSelectCategory,
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
        // Reuses the exact same media grid + full-screen viewer as the public
        // profile page, so a profile's media looks and behaves identically
        // whether you're viewing it here (Profile Management) or on the
        // profile itself — same likes/comments/share, same tap-to-view.
        ProfileMediaSection(
          mediaUrls: profile.mediaUrls,
          profileName: profile.displayName,
          avatarUrl: profile.avatarUrl,
        ),
        const SizedBox(height: AppSpacing.lg),
        PromooButton.primary(
          label: _isSaving ? l10n.profileEditSaving : l10n.profileEditSaveButton,
          fullWidth: true,
          onPressed: _isSaving ? null : () => _handleSave(l10n),
        ),
      ],
    );
  }

  Future<void> _handleSave(AppLocalizations l10n) async {
    setState(() => _isSaving = true);

    final draft = ProfileUpdateDraft(
      displayName: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );
    final result = await ref
        .read(profileRepositoryProvider)
        .updateMyProfile(draft);

    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);

    result.when(
      success: (_) {
        ref.invalidate(editProfileSourceProvider);
        ref.invalidate(profileControllerProvider);
        _showNotice(l10n.profileEditSaveSuccess);
      },
      failure: (failure) => _showNotice(failure.message),
    );
  }

  /// The full avatar flow: choose a source → pick a local image → upload it
  /// (bucket `avatars`, related `profile`) which returns a Supabase Storage URL
  /// → persist that URL via `POST /profiles/me/avatar` → refresh the profile so
  /// the new photo shows here, on the profile menu welcome card, and elsewhere.
  Future<void> _pickAndUploadAvatar(AppLocalizations l10n) async {
    final source = await _chooseImageSource(l10n);
    if (source == null || !mounted) {
      return;
    }

    final XFile? picked;
    try {
      picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
    } catch (_) {
      if (mounted) _showNotice(l10n.profileEditUnavailableMessage);
      return;
    }
    if (picked == null || !mounted) {
      return;
    }

    setState(() => _isUploadingAvatar = true);

    final uploadResult = await ref
        .read(uploadRepositoryProvider)
        .uploadImage(
          filePath: picked.path,
          bucket: UploadBucket.avatars,
          relatedTo: UploadRelatedTo.profile,
        );
    if (!mounted) {
      return;
    }

    switch (uploadResult) {
      case Success(data: final media):
        final saveResult = await ref
            .read(profileRepositoryProvider)
            .updateMyAvatar(media.fileUrl);
        if (!mounted) {
          return;
        }
        setState(() => _isUploadingAvatar = false);
        saveResult.when(
          success: (_) {
            ref.invalidate(editProfileSourceProvider);
            ref.invalidate(profileControllerProvider);
            _showNotice(l10n.profileEditPhotoUpdated);
          },
          failure: (failure) => _showNotice(failure.message),
        );
      case Failure(failure: final failure):
        setState(() => _isUploadingAvatar = false);
        _showNotice(failure.message);
    }
  }

  Future<ImageSource?> _chooseImageSource(AppLocalizations l10n) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: context.colors.elevatedSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: Text(l10n.profileEditTakePhoto),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.profileEditChooseFromGallery),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
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
        color: context.colors.cardSurface,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.colors.textSecondary),
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
