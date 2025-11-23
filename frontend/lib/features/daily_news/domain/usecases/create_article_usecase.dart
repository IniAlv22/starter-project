import 'package:news_app_symmetry/core/resources/data_state.dart';
import '../repository/article_repository.dart';
import 'params/create_article_params.dart';

class CreateArticleUseCase {
  final ArticleRepository repository;
  CreateArticleUseCase(this.repository);

  Future<DataState<void>> call(CreateArticleParams params) {
    return repository.createArticle(params);
  }
}
