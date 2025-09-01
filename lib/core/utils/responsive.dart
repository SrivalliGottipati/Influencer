import 'package:flutter/widgets.dart';

enum DeviceSize { xs, sm, md, lg, xl }

class Responsive {
  final BuildContext context;
  final double width;
  final double height;
  Responsive(this.context) : width = MediaQuery.sizeOf(context).width, height = MediaQuery.sizeOf(context).height;

  DeviceSize get device {
    if (width < 360) return DeviceSize.xs;
    if (width < 600) return DeviceSize.sm;
    if (width < 840) return DeviceSize.md;
    if (width < 1200) return DeviceSize.lg;
    return DeviceSize.xl;
  }

  double scale([double factor = 1]) {
    final base = 380.0;
    final max = 1200.0;
    final s = (width / base).clamp(0.75, max / base);
    return s * factor;
  }

  double spacing(double base) => base * scale();
  double fontSize(double base) => base * scale();

  bool get isXs => device == DeviceSize.xs;
  bool get isPhone => device == DeviceSize.sm;
  bool get isLargePhone => device == DeviceSize.md;
  bool get isTablet => device == DeviceSize.lg;
  bool get isDesktop => device == DeviceSize.xl;
}

extension ResponsiveExt on BuildContext {
  Responsive get responsive => Responsive(this);
}
