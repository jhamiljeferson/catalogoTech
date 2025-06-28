import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class StandardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final VoidCallback? onTap;
  final bool isActive;

  const StandardCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.actions,
    this.onTap,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyles.title.copyWith(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(subtitle!, style: TextStyles.subtitle)
                : null,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
      ),
    );
  }
}
