import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adhikar/theme/pallete_theme.dart';

class BadgeIcon extends StatelessWidget {
  final String iconPath;
  final int badgeCount;
  final double iconHeight;
  final Color iconColor;
  final VoidCallback? onTap;

  const BadgeIcon({
    super.key,
    required this.iconPath,
    required this.badgeCount,
    this.iconHeight = 30,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            height: iconHeight,
          ),
          if (badgeCount > 0)
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Pallete.backgroundColor, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
