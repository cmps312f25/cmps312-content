import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Responsive Theme System
///
/// This file provides a comprehensive responsive design system with 5 breakpoints
/// and utilities for building adaptive layouts across different screen sizes.

// ==================== Breakpoint Definitions ====================

enum Breakpoint { mobile, mobileLarge, tablet, desktop, desktopLarge }

class BreakpointConfig {
  BreakpointConfig._();

  static const double mobile = 600;
  static const double mobileLarge = 905;
  static const double tablet = 1240;
  static const double desktop = 1440;

  static Breakpoint fromWidth(double width) {
    if (width < mobile) return Breakpoint.mobile;
    if (width < mobileLarge) return Breakpoint.mobileLarge;
    if (width < tablet) return Breakpoint.tablet;
    if (width < desktop) return Breakpoint.desktop;
    return Breakpoint.desktopLarge;
  }
}

// ==================== Responsive Value System ====================

class ResponsiveValue<T> {
  final T mobile;
  final T? mobileLarge;
  final T? tablet;
  final T? desktop;
  final T? desktopLarge;

  const ResponsiveValue({
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    this.desktop,
    this.desktopLarge,
  });

  T getValue(Breakpoint breakpoint) {
    switch (breakpoint) {
      case Breakpoint.mobile:
        return mobile;
      case Breakpoint.mobileLarge:
        return mobileLarge ?? mobile;
      case Breakpoint.tablet:
        return tablet ?? mobileLarge ?? mobile;
      case Breakpoint.desktop:
        return desktop ?? tablet ?? mobileLarge ?? mobile;
      case Breakpoint.desktopLarge:
        return desktopLarge ?? desktop ?? tablet ?? mobileLarge ?? mobile;
    }
  }
}

// ==================== Responsive Spacing ====================

class ResponsiveSpacing {
  ResponsiveSpacing._();

  static ResponsiveValue<double> get xs =>
      const ResponsiveValue(mobile: 4, tablet: 6, desktop: 8);
  static ResponsiveValue<double> get sm =>
      const ResponsiveValue(mobile: 8, tablet: 12, desktop: 16);
  static ResponsiveValue<double> get md =>
      const ResponsiveValue(mobile: 16, tablet: 20, desktop: 24);
  static ResponsiveValue<double> get lg =>
      const ResponsiveValue(mobile: 24, tablet: 32, desktop: 48);
  static ResponsiveValue<double> get xl =>
      const ResponsiveValue(mobile: 32, tablet: 48, desktop: 80);
  static ResponsiveValue<double> get pageHorizontal =>
      const ResponsiveValue(mobile: 16, tablet: 32, desktop: 64);
  static ResponsiveValue<double> get pageVertical =>
      const ResponsiveValue(mobile: 16, tablet: 24, desktop: 40);
}

class ResponsiveLayout {
  ResponsiveLayout._();

  static ResponsiveValue<double> get appBarHeight =>
      const ResponsiveValue(mobile: 56, tablet: 64, desktop: 72);
  static ResponsiveValue<int> get gridColumns =>
      const ResponsiveValue(mobile: 2, mobileLarge: 3, tablet: 4, desktop: 5);
  static ResponsiveValue<double> get storyCardAspectRatio =>
      const ResponsiveValue(mobile: 0.7, tablet: 0.8);
}

class ResponsiveBorderRadius {
  ResponsiveBorderRadius._();

  static ResponsiveValue<double> get sm =>
      const ResponsiveValue(mobile: 8, tablet: 10, desktop: 12);
  static ResponsiveValue<double> get md =>
      const ResponsiveValue(mobile: 12, tablet: 16, desktop: 20);
  static ResponsiveValue<double> get lg =>
      const ResponsiveValue(mobile: 16, tablet: 20, desktop: 28);
}

// ==================== Responsive Extensions ====================

extension ResponsiveContext on BuildContext {
  Breakpoint get breakpoint {
    final width = MediaQuery.of(this).size.width;
    return BreakpointConfig.fromWidth(width);
  }

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < BreakpointConfig.mobile;
  bool get isTabletOrLarger => screenWidth >= BreakpointConfig.mobileLarge;
  bool get isDesktopOrLarger => screenWidth >= BreakpointConfig.tablet;

  T responsive<T>(ResponsiveValue<T> value) {
    return value.getValue(breakpoint);
  }
}

extension ResponsiveRef on WidgetRef {
  Breakpoint get breakpoint {
    final width = MediaQuery.of(context).size.width;
    return BreakpointConfig.fromWidth(width);
  }

  T responsive<T>(ResponsiveValue<T> value) {
    return value.getValue(breakpoint);
  }
}

// ==================== Responsive Widgets ====================

class ResponsivePadding extends ConsumerWidget {
  final Widget child;
  final ResponsiveValue<double>? all;
  final ResponsiveValue<double>? horizontal;
  final ResponsiveValue<double>? vertical;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
  });

  factory ResponsivePadding.page({Key? key, required Widget child}) {
    return ResponsivePadding(
      key: key,
      horizontal: ResponsiveSpacing.pageHorizontal,
      vertical: ResponsiveSpacing.pageVertical,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakpoint = ref.breakpoint;
    final leftValue =
        horizontal?.getValue(breakpoint) ?? all?.getValue(breakpoint) ?? 0;
    final topValue =
        vertical?.getValue(breakpoint) ?? all?.getValue(breakpoint) ?? 0;
    final rightValue =
        horizontal?.getValue(breakpoint) ?? all?.getValue(breakpoint) ?? 0;
    final bottomValue =
        vertical?.getValue(breakpoint) ?? all?.getValue(breakpoint) ?? 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        leftValue,
        topValue,
        rightValue,
        bottomValue,
      ),
      child: child,
    );
  }
}

class ResponsiveGap extends ConsumerWidget {
  final ResponsiveValue<double> size;
  final Axis axis;

  const ResponsiveGap(this.size, {super.key, this.axis = Axis.vertical});

  factory ResponsiveGap.xs({Key? key, Axis axis = Axis.vertical}) {
    return ResponsiveGap(ResponsiveSpacing.xs, key: key, axis: axis);
  }

  factory ResponsiveGap.sm({Key? key, Axis axis = Axis.vertical}) {
    return ResponsiveGap(ResponsiveSpacing.sm, key: key, axis: axis);
  }

  factory ResponsiveGap.md({Key? key, Axis axis = Axis.vertical}) {
    return ResponsiveGap(ResponsiveSpacing.md, key: key, axis: axis);
  }

  factory ResponsiveGap.lg({Key? key, Axis axis = Axis.vertical}) {
    return ResponsiveGap(ResponsiveSpacing.lg, key: key, axis: axis);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.responsive(size);
    return SizedBox(
      width: axis == Axis.horizontal ? value : null,
      height: axis == Axis.vertical ? value : null,
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Breakpoint breakpoint) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = BreakpointConfig.fromWidth(constraints.maxWidth);
        return builder(context, breakpoint);
      },
    );
  }
}

/// Widget that switches between different layouts based on breakpoint
class ResponsiveLayoutSwitcher extends StatelessWidget {
  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? desktopLarge;

  const ResponsiveLayoutSwitcher({
    super.key,
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    this.desktop,
    this.desktopLarge,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;
    switch (breakpoint) {
      case Breakpoint.mobile:
        return mobile;
      case Breakpoint.mobileLarge:
        return mobileLarge ?? mobile;
      case Breakpoint.tablet:
        return tablet ?? mobileLarge ?? mobile;
      case Breakpoint.desktop:
        return desktop ?? tablet ?? mobileLarge ?? mobile;
      case Breakpoint.desktopLarge:
        return desktopLarge ?? desktop ?? tablet ?? mobileLarge ?? mobile;
    }
  }
}
