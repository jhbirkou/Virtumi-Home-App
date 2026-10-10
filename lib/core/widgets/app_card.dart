import 'package:flutter/material.dart';



import '../theme/theme.dart';

import 'neumorphic_container.dart';



/// Global card component used across all screens.

///

/// Renders a raised neumorphic surface and, when [onTap] is provided, adds the

/// tactile `scale 0.95` press feedback specified in the design system.

class AppCard extends StatefulWidget {

  const AppCard({

    super.key,

    required this.child,

    this.onTap,

    this.padding = const EdgeInsets.all(AppSpacing.md),

    this.borderRadius,

    this.style = NeumorphicStyle.raised,

    this.color,

    this.width,

    this.semanticLabel,

  });



  final Widget child;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry padding;

  final BorderRadius? borderRadius;

  final NeumorphicStyle style;

  final Color? color;

  final double? width;

  final String? semanticLabel;



  @override

  State<AppCard> createState() => _AppCardState();

}



class _AppCardState extends State<AppCard> {

  bool _pressed = false;



  void _setPressed(bool value) {

    if (widget.onTap == null) return;

    setState(() => _pressed = value);

  }



  @override

  Widget build(BuildContext context) {

    final radius = widget.borderRadius ?? AppRadius.cardAll;



    Widget card = NeumorphicContainer(

      style: widget.style,

      borderRadius: radius,

      padding: widget.padding,

      width: widget.width,

      color: widget.color,

      child: widget.child,

    );



    if (widget.onTap != null) {

      card = AnimatedScale(

        scale: _pressed ? 0.98 : 1.0,

        duration: const Duration(milliseconds: 120),

        curve: Curves.easeOut,

        child: card,

      );

    }



    return Semantics(

      button: widget.onTap != null,

      label: widget.semanticLabel,

      child: GestureDetector(

        onTap: widget.onTap,

        onTapDown: (_) => _setPressed(true),

        onTapUp: (_) => _setPressed(false),

        onTapCancel: () => _setPressed(false),

        behavior: HitTestBehavior.opaque,

        child: card,

      ),

    );

  }

}

