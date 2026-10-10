import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// QR pairing card with encoded payload text and manual setup code.
class MatterQrPairingCard extends StatelessWidget {
  const MatterQrPairingCard({
    super.key,
    required this.qrPayload,
    required this.setupCode,
  });

  final String qrPayload;
  final String setupCode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Column(
        children: [
          Text(
            'MATTER PAIRING QR-CODE',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.cardAll,
              border: Border.all(color: context.palette.divider),
              boxShadow: context.palette.raisedSmall,
            ),
            child: QrImageView(
              data: qrPayload,
              size: 192,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.gutter),
          Text(
            qrPayload.toLowerCase(),
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'SETUP-CODE',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            setupCode,
            style: context.text.headlineSmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
