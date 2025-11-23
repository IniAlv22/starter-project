import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_symmetry/config/theme/theme_cubit.dart';

import '../../widgets/symmetry_app_bar.dart';
import '../../widgets/symmetry_footer.dart';

class AddArticle extends StatelessWidget {
  const AddArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          _buildSectionHeader(context),
          _buildContent(context),
          const SymmetryFooter(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SymmetryAppBar(
      isDarkMode: context.watch<ThemeCubit>().state,
      onToggleTheme: () => context.read<ThemeCubit>().toggleTheme(),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _onBackButtonTapped(context),
                child: Icon(
                  Icons.chevron_left,
                  size: 28,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Create article",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () {}, // AQUI IMPLEMENTA LA ACCIÓN DE GUARDAR EL ARTICULO QUE HAS CREADO.
            child: Icon(
              Icons.save,
              size: 24,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

// =====================================================
// AQUI VA EL CONTENIDO Y LOS FORMS PARA CREAR UN ARTICULO O PARA IMPORTARLO
// =====================================================
  Widget _buildContent(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return Expanded(
      child: Center(
        child: Text(
          "CONTENT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }
}
