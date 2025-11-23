import 'package:news_app_symmetry/core/resources/data_state.dart';
import 'package:news_app_symmetry/features/daily_news/domain/entities/article.dart';
import 'package:news_app_symmetry/features/daily_news/domain/usecases/params/create_article_params.dart';

abstract class ArticleRepository {
  // API methods
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  // Database methods
  Future < List < ArticleEntity >> getSavedArticles();

  Future < void > saveArticle(ArticleEntity article);

  Future < void > removeArticle(ArticleEntity article);

   Future<DataState<void>> createArticle(CreateArticleParams params);
}