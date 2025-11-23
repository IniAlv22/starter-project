import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import 'package:news_app_symmetry/config/theme/theme_cubit.dart';
import 'package:news_app_symmetry/config/theme/app_colors.dart';

import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';

class ArticleDetailsView extends HookWidget {
  final ArticleEntity? article;

  const ArticleDetailsView({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onBackButtonTapped(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            Ionicons.chevron_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => _onSaveArticleTapped(context),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Ionicons.bookmark_outline,
              size: 24,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSection(context),
          _buildImageSection(),
          _buildDescriptionSection(context),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(isDarkMode),
          const SizedBox(height: 10),
          _buildDate(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isDarkMode) {
    return Text(
      article!.title ?? "",
      style: TextStyle(
        fontFamily: 'Butler',
        fontSize: 26,
        fontWeight: FontWeight.w900,
        height: 1.2,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildDate(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Ionicons.time_outline,
          size: 16,
          color: isDarkMode ? Colors.white70 : Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          article!.publishedAt ?? "",
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          article!.urlToImage ?? "",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Text(
        _buildFullDescription(),
        style: TextStyle(
          fontSize: 16,
          height: 1.4,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  String _buildFullDescription() {
    final description = article!.description ?? "";
    final content = article!.content ?? "";
    return "$description\n\n$content";
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onSaveArticleTapped(BuildContext context) {
    BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black,
        content: Text('Article saved successfully.'),
      ),
    );
  }
}
