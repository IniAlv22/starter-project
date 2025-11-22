import 'package:dio/dio.dart';
import 'package:news_app_symmetry/core/resources/data_state.dart';
import 'package:news_app_symmetry/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_symmetry/features/daily_news/data/data_sources/remote/firestore_article_service.dart';
import 'package:news_app_symmetry/features/daily_news/data/models/article.dart';
import 'package:news_app_symmetry/features/daily_news/domain/entities/article.dart';
import 'package:news_app_symmetry/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final FirestoreArticleService _remoteDataSource;
  final AppDatabase _localDataSource;

  ArticleRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  // 🔥 FIRESTORE — get remote articles
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final articles = await _remoteDataSource.getArticles();

      // Muy importante: asegurar siempre un DataSuccess correcto
      return DataSuccess<List<ArticleModel>>(articles);

    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  // 🔵 LOCAL DATABASE — get saved (Floor)
  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _localDataSource.articleDAO.getArticles();
  }

  // 🔵 LOCAL DATABASE — remove article
  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _localDataSource.articleDAO
        .deleteArticle(ArticleModel.fromEntity(article));
  }

  // 🔵 LOCAL DATABASE — save article
  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _localDataSource.articleDAO
        .insertArticle(ArticleModel.fromEntity(article));
  }
}