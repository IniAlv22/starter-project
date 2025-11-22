import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/data/data_sources/remote/firestore_article_service.dart';
import 'features/daily_news/data/repository/article_repository_impl.dart';
import 'features/daily_news/domain/repository/article_repository.dart';

import 'features/daily_news/domain/usecases/get_article.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';

import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  // FLOOR DB
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  sl.registerSingleton<AppDatabase>(database);

  // DIO
  sl.registerSingleton<Dio>(Dio());

  // FIRESTORE INSTANCE - ESTA ES LA BUENA
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // FIRESTORE SERVICE - USA LA INSTANCE BUENA
  sl.registerLazySingleton<FirestoreArticleService>(
    () => FirestoreArticleService(sl<FirebaseFirestore>()),
  );

  // REPOSITORY
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(
      sl<FirestoreArticleService>(),
      sl<AppDatabase>(),
    ),
  );

  // USE CASES
  sl.registerLazySingleton<GetArticleUseCase>(
    () => GetArticleUseCase(sl()),
  );
  sl.registerLazySingleton<GetSavedArticleUseCase>(
    () => GetSavedArticleUseCase(sl()),
  );
  sl.registerLazySingleton<SaveArticleUseCase>(
    () => SaveArticleUseCase(sl()),
  );
  sl.registerLazySingleton<RemoveArticleUseCase>(
    () => RemoveArticleUseCase(sl()),
  );

  // BLOCS
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
  sl.registerFactory<LocalArticleBloc>(() => LocalArticleBloc(sl(), sl(), sl()));
}