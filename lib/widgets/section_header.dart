import 'package:flutter/material.dart';

/// مكون رأس القسم
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 32,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
