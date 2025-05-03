import 'package:flutter/material.dart';

class CircleOutlineButton extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final bool fill;
  final VoidCallback? onTap;

  const CircleOutlineButton({
    Key? key,
    required this.icon,
    required this.accent,
    this.onTap,
    this.fill = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill ? accent : Colors.transparent,
          border: Border.all(color: accent, width: 2.5),
          boxShadow: fill
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.22),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Icon(
            icon,
            color: fill ? Colors.black : accent,
            size: 32,
          ),
        ),
      ),
    );
  }
}
