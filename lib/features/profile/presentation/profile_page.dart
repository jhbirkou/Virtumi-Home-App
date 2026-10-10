import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/extensions/accent_resolver.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/avatar_url_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/data_providers.dart';
import '../../../shared/providers/repository_providers.dart';

/// User profile ("Mein Profil") with editable account fields.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _postalCode = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();

  bool _editing = false;
  bool _initialized = false;
  bool _saving = false;
  String? _pendingAvatarUrl;
  Uint8List? _pendingAvatarBytes;

  @override
  void dispose() {
    for (final c in [
      _firstName,
      _lastName,
      _email,
      _phone,
      _street,
      _postalCode,
      _city,
      _country,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _hydrate(User user) {
    if (_initialized) return;
    _firstName.text = user.firstName;
    _lastName.text = user.lastName;
    _email.text = user.email;
    _phone.text = user.phone;
    _street.text = user.addressStreet;
    _postalCode.text = user.addressPostalCode;
    _city.text = user.addressCity;
    _country.text = user.addressCountry;
    _pendingAvatarUrl = user.avatarUrl;
    _pendingAvatarBytes = null;
    _initialized = true;
  }

  Future<void> _evictAvatarCache(String? url) async {
    if (url == null || url.isEmpty) return;
    await CachedNetworkImage.evictFromCache(url);
    final base = avatarBaseUrl(url);
    if (base != url) {
      await CachedNetworkImage.evictFromCache(base);
    }
  }

  Future<void> _pickAvatar(User user) async {
    if (!_editing || _saving) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;

    setState(() {
      _pendingAvatarBytes = bytes;
      _saving = true;
    });

    try {
      final ext = file.path.split('.').last.toLowerCase();
      final safeExt = ['png', 'webp', 'jpg', 'jpeg'].contains(ext) ? ext : 'jpg';
      final previousUrl = _pendingAvatarUrl ?? user.avatarUrl;
      final url = await ref.read(userRepositoryProvider).uploadAvatar(
            user.id,
            bytes,
            safeExt == 'jpeg' ? 'jpg' : safeExt,
          );
      await _evictAvatarCache(previousUrl);
      if (!mounted) return;
      setState(() {
        _pendingAvatarUrl = url;
        _pendingAvatarBytes = null;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _pendingAvatarBytes = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profilbild konnte nicht hochgeladen werden: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _save(User base) async {
    setState(() => _saving = true);
    try {
      final updated = base.copyWith(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        name: '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        addressStreet: _street.text.trim(),
        addressPostalCode: _postalCode.text.trim(),
        addressCity: _city.text.trim(),
        addressCountry: _country.text.trim(),
        avatarUrl: _pendingAvatarUrl,
      );
      await ref.read(userRepositoryProvider).updateUser(updated);
      ref.invalidate(currentUserProvider);
      if (mounted) setState(() => _editing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil konnte nicht gespeichert werden: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final p = context.palette;

    return AppScaffold(
      header: AppHeader(
        isEditing: _editing,
        onEdit: () => setState(() => _editing = !_editing),
        onRefresh: () => ref.invalidate(currentUserProvider),
      ),
      body: AsyncValueView<User>(
        value: userAsync,
        onRetry: () => ref.invalidate(currentUserProvider),
        data: (user) {
          _hydrate(user);
          final avatarUrl = _pendingAvatarUrl ?? user.avatarUrl;

          return AppScrollView(
            children: [
              _ProfileHeader(
                user: user,
                avatarUrl: avatarUrl,
                avatarBytes: _pendingAvatarBytes,
                editing: _editing,
                saving: _saving,
                onPickAvatar: () => _pickAvatar(user),
              ),
              const AppSectionLabel('Persönliche Daten'),
              GroupedListCard(
                children: [
                  SettingsInputRow(
                    icon: Symbols.person,
                    label: 'Vorname',
                    controller: _firstName,
                    iconColor: p.accentBlue,
                    enabled: _editing && !_saving,
                  ),
                  SettingsInputRow(
                    icon: Symbols.badge,
                    label: 'Nachname',
                    controller: _lastName,
                    iconColor: p.accentIndigo,
                    enabled: _editing && !_saving,
                  ),
                  SettingsInputRow(
                    icon: Symbols.mail,
                    label: 'E-Mail',
                    controller: _email,
                    iconColor: p.accentIndigo,
                    enabled: _editing && !_saving,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SettingsInputRow(
                    icon: Symbols.phone,
                    label: 'Telefon',
                    controller: _phone,
                    iconColor: p.accentTeal,
                    enabled: _editing && !_saving,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              const AppSectionLabel('Adresse'),
              GroupedListCard(
                children: [
                  SettingsInputRow(
                    icon: Symbols.home,
                    label: 'Straße',
                    controller: _street,
                    iconColor: p.accentOrange,
                    enabled: _editing && !_saving,
                  ),
                  SettingsInputRow(
                    icon: Symbols.markunread_mailbox,
                    label: 'PLZ',
                    controller: _postalCode,
                    iconColor: p.accentAmber,
                    enabled: _editing && !_saving,
                    keyboardType: TextInputType.number,
                  ),
                  SettingsInputRow(
                    icon: Symbols.location_city,
                    label: 'Stadt',
                    controller: _city,
                    iconColor: p.accentSky,
                    enabled: _editing && !_saving,
                  ),
                  SettingsInputRow(
                    icon: Symbols.public,
                    label: 'Land',
                    controller: _country,
                    iconColor: p.accentPurple,
                    enabled: _editing && !_saving,
                  ),
                ],
              ),
              if (_editing)
                SaveCancelCard(
                  onCancel: () => setState(() {
                    _initialized = false;
                    _hydrate(user);
                    _editing = false;
                  }),
                  onSave: () => _save(user),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.avatarUrl,
    this.avatarBytes,
    required this.editing,
    required this.saving,
    required this.onPickAvatar,
  });

  final User user;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final bool editing;
  final bool saving;
  final VoidCallback onPickAvatar;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              UserAvatar(
                initials: user.initials,
                imageUrl: avatarUrl,
                imageBytes: avatarBytes,
                size: 88,
                showStatus: true,
                isOnline: user.isOnline,
                heroTag: 'profile-avatar',
              ),
              if (editing)
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Material(
                    color: context.colors.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: saving ? null : onPickAvatar,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Symbols.photo_camera,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.gutter),
          Text(user.displayName, style: context.text.headlineMedium),
          const SizedBox(height: 2),
          Text(user.email, style: context.text.bodySmall),
          if (user.fullAddress.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              user.fullAddress,
              textAlign: TextAlign.center,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          if (user.badges.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              alignment: WrapAlignment.center,
              children: [
                for (final badge in user.badges)
                  _Pill(
                    label: badge.label,
                    color: context.accent(badge.accentKey),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.full,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: context.text.labelSmall?.copyWith(
          color: color,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
