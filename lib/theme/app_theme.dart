import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const primaryDark = Color(0xFF0D47A1);
  static const primaryDeep = Color(0xFF073B86);

  static const backgroundTop = Color(0xFFEFF8FF);
  static const backgroundBottom = Color(0xFFF8FCFF);

  static const card = Colors.white;
  static const softBlue = Color(0xFFE3F2FD);
  static const softerBlue = Color(0xFFF3FAFF);

  static const textDark = Color(0xFF0D2B5C);
  static const textMuted = Color(0xFF9E9E9E);

  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const danger = Color(0xFFFF5252);
}

class AppRadius {
  static const double small = 14;
  static const double medium = 18;
  static const double card = 24;
  static const double large = 28;
  static const double button = 28;
}

class AppShadow {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.28),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}

class AquaBackground extends StatelessWidget {
  final Widget child;

  const AquaBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundTop,
            AppColors.backgroundBottom,
          ],
        ),
      ),
      child: child,
    );
  }
}

class AquaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final List<BoxShadow>? boxShadow;

  const AquaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = AppRadius.card,
    this.color = AppColors.card,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: boxShadow ?? AppShadow.card,
      ),
      child: child,
    );
  }
}

class AquaPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const AquaPrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.button),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2FAAF7),
              Color(0xFF0078E8),
            ],
          ),
          boxShadow: AppShadow.button,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
