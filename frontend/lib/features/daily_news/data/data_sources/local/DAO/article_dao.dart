import 'package:floor/floor.dart';
import 'package:news_app_symmetry/features/daily_news/data/models/article.dart';

@dao
abstract class ArticleDao {

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertArticle(ArticleModel article);

  @delete
  Future<void> deleteArticle(ArticleModel article);

  @Query('SELECT * FROM article')
  Future<List<ArticleModel>> getArticles();
}