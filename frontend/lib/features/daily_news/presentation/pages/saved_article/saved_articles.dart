import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app_symmetry/config/theme/theme_cubit.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import 'package:news_app_symmetry/features/daily_news/presentation/widgets/article_tile.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/widgets/symmetry_app_bar.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/widgets/symmetry_footer.dart';

import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';

class SavedArticles extends StatelessWidget {
  const SavedArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          _buildSectionHeader(context),
          _buildArticlesListContainer(context),
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
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 44),
      child: Row(
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
            "Saved articles",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesListContainer(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LocalArticleBloc, LocalArticlesState>(
        builder: (context, state) {
          if (state is LocalArticlesLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (state is LocalArticlesDone) {
            return _buildArticlesList(context, state.articles!);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildArticlesList(
      BuildContext context, List<ArticleEntity> articles) {
    if (articles.isEmpty) {
      return const Center(
        child: Text(
          "NO SAVED ARTICLES",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: articles.length,
      itemBuilder: (_, index) {
        return ArticleWidget(
          article: articles[index],
          isRemovable: true,
          onRemove: (article) => _onRemoveArticle(context, article),
          onArticlePressed: (article) => _onArticlePressed(context, article),
        );
      },
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onRemoveArticle(BuildContext context, ArticleEntity article) {
    BlocProvider.of<LocalArticleBloc>(context).add(RemoveArticle(article));
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
