import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Rounded user avatar with an optional online indicator.
///
/// Prefer [imageBytes] for an instant local preview after picking a photo.
/// Otherwise renders a cached network image when [imageUrl] is set, or a
/// gradient tile with the user's initials.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.imageBytes,
    this.size = AppSizes.avatar,
    this.showStatus = false,
    this.isOnline = true,
    this.borderRadius,
    this.heroTag,
  });

  final String initials;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final double size;
  final bool showStatus;
  final bool isOnline;
  final BorderRadius? borderRadius;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.mdAll;

    Widget content = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary.withValues(alpha: 0.25),
            context.palette.accentTeal.withValues(alpha: 0.25),
          ],
        ),
        borderRadius: radius,
      ),
      child: Center(
        child: Text(
          initials,
          style: context.text.titleMedium?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (imageBytes != null && imageBytes!.isNotEmpty) {
      content = Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      final fallback = content;
      content = CachedNetworkImage(
        imageUrl: imageUrl!,
        cacheKey: imageUrl,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      );
    }

    Widget avatar = ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: size, height: size, child: content),
    );

    if (heroTag != null) {
      avatar = Hero(tag: heroTag!, child: avatar);
    }

    if (!showStatus) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: size * 0.26,
            height: size * 0.26,
            decoration: BoxDecoration(
              color: isOnline ? context.palette.statusOnline : context.colors.outline,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
