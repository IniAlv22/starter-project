import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_symmetry/config/theme/theme_cubit.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';
import '../../widgets/symmetry_app_bar.dart';
import '../../widgets/symmetry_footer.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPage();
  }

  _buildPage() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return Scaffold(
            body: Column(
              children: [
                SymmetryAppBar(
                  isDarkMode: context.watch<ThemeCubit>().state,
                  onToggleTheme: () => context.read<ThemeCubit>().toggleTheme(),
                ),

                _buildSectionHeader(context),

                const Expanded(
                  child: Center(child: CupertinoActivityIndicator()),
                ),
              ],
            ),
          );
        }

        if (state is RemoteArticlesError) {
          return Scaffold(
            body: Column(
              children: [
                SymmetryAppBar(
                  isDarkMode: context.watch<ThemeCubit>().state,
                  onToggleTheme: () => context.read<ThemeCubit>().toggleTheme(),
                ),

                _buildSectionHeader(context),

                const Expanded(
                  child: Center(child: Icon(Icons.refresh)),
                ),
              ],
            ),
          );
        }

        if (state is RemoteArticlesDone) {
          return _buildArticlesPage(context, state.articles!);
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildArticlesPage(
      BuildContext context, List<ArticleEntity> articles) {
    return Scaffold(
      body: Column(
        children: [
          SymmetryAppBar(
            isDarkMode: context.watch<ThemeCubit>().state,
            onToggleTheme: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          _buildSectionHeader(context),
          // Lista de artículos
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (_, i) {
                return ArticleWidget(
                  article: articles[i],
                  onArticlePressed: (article) =>
                      _onArticlePressed(context, article),
                );
              },
            ),
          ),
          const SymmetryFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
  final bool isDarkMode = context.watch<ThemeCubit>().state;

  return Padding(
    padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Featured articles",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),

        /// ICONOS: guardados y botón de añadir
        Row(
          children: [
            GestureDetector(
              onTap: () => _onShowSavedArticlesViewTapped(context),
              child: Icon(
                Icons.folder,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(width: 16),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/AddArticle'),
              child: Icon(
                Icons.add,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
