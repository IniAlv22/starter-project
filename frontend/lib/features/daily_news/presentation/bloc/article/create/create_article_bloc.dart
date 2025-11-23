import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_article_event.dart';
import 'create_article_state.dart';
import '../../../../domain/usecases/create_article_usecase.dart';
import '../../../../domain/usecases/params/create_article_params.dart';
import 'package:news_app_symmetry/core/resources/data_state.dart';


class CreateArticleBloc extends Bloc<CreateArticleEvent, CreateArticleState> {
  final CreateArticleUseCase createArticleUseCase;

  CreateArticleBloc(this.createArticleUseCase)
      : super(CreateArticleInitial()) {
    on<SubmitArticleEvent>(_onSubmitArticle);
  }

  Future<void> _onSubmitArticle(
    SubmitArticleEvent event,
    Emitter<CreateArticleState> emit,
  ) async {
    emit(CreateArticleLoading());

    final result = await createArticleUseCase(
      CreateArticleParams(
        title: event.title,
        description: event.description,
        imagePath: event.imagePath,
      ),
    );

    if (result is DataSuccess) {
      emit(CreateArticleSuccess());
    } else {
      emit(CreateArticleFailure(result.error?.message ?? "Unknown Error"));
    }
  }
}
