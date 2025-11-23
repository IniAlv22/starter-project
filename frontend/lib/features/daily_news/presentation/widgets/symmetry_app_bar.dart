import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app_symmetry/core/resources/app_icons.dart';
import 'package:news_app_symmetry/config/theme/app_colors.dart';

class SymmetryAppBar extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const SymmetryAppBar({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBackground(
      child: _buildContent(),
    );
  }

  Widget _buildBackground({required Widget child}) {
    final Color backgroundColor =
        isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(),
        _buildThemeToggle(),
      ],
    );
  }

  Widget _buildLogo() {
    return SvgPicture.asset(
      isDarkMode ? AppIcons.darkSymmetryLogo : AppIcons.lightSymmetryLogo,
      height: 40,
    );
  }

  Widget _buildThemeToggle() {
    return GestureDetector(
      onTap: onToggleTheme,
      child: SvgPicture.asset(
        isDarkMode ? AppIcons.darkModeIcon : AppIcons.lightModeIcon,
        height: 28,
      ),
    );
  }
}