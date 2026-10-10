import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Base scaffold for every screen.
///
/// Handles the neumorphic background, a fixed (non-scrolling) [header] area, and
/// a centered, width-constrained content region for a consistent "handheld
/// remote" feel on tablets/desktop. The floating bottom navigation is provided
/// once by the navigation shell and overlays the content.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.header,
    required this.body,
    this.maxContentWidth = AppSizes.maxContentWidth,
  });

  final Widget? header;
  final Widget body;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?header,
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard scrolling content region with consistent horizontal padding and
/// bottom clearance so content can scroll clear of the floating nav bar.
class AppScrollView extends StatelessWidget {
  const AppScrollView({
    super.key,
    required this.children,
    this.spacing = AppSpacing.cardGap,
    this.padding,
    this.bottomClearance,
    this.controller,
  });

  final List<Widget> children;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  /// When null, uses [AppSpacing.scrollBottomClearance] (nav + system inset + gap).
  final double? bottomClearance;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final resolvedBottomClearance =
        bottomClearance ?? AppSpacing.scrollBottomClearance(context);
    final resolvedPadding = padding ??
        EdgeInsets.fromLTRB(
          AppSpacing.containerPadding,
          AppSpacing.gutter,
          AppSpacing.containerPadding,
          resolvedBottomClearance,
        );

    return SingleChildScrollView(
      controller: controller,
      clipBehavior: Clip.hardEdge,
      padding: resolvedPadding,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(children, spacing),
      ),
    );
  }

  List<Widget> _withSpacing(List<Widget> items, double gap) {
    if (items.isEmpty) return items;
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i != items.length - 1) result.add(SizedBox(height: gap));
    }
    return result;
  }
}
