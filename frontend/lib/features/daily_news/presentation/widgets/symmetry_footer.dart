import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_symmetry/config/theme/app_colors.dart';
import 'package:news_app_symmetry/config/theme/theme_cubit.dart';

class SymmetryFooter extends StatelessWidget {
  const SymmetryFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildFooterText(context);
  }

  Widget _buildFooterText(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 40),
      child: Center(
        child: Text(
          "This project is done by Iñigo Alvaro to apply to Symmetry",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
        ),
      ),
    );
  }
}