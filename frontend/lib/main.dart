import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_symmetry/config/routes/routes.dart';

import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/create/create_article_bloc.dart';

import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/pages/home/daily_news.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

import 'config/theme/app_themes.dart';
import 'config/theme/theme_cubit.dart';

import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();

  // solo debug
  final snapshot = await FirebaseFirestore.instance.collection('articles').get();
  print("ARTICLES COUNT: ${snapshot.docs.length}");

  runApp(
    MultiBlocProvider(
      providers: [
        /// THEME CUBIT → controla modo oscuro
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),

        /// REMOTE ARTICLES BLOC → para cargar noticias
        BlocProvider<RemoteArticlesBloc>(
          create: (context) =>
              sl<RemoteArticlesBloc>()..add(const GetArticles()),
        ),
        /// LOCAL ARTICLES → guardar / eliminar favoritos
        BlocProvider<LocalArticleBloc>(
          create: (_) => sl<LocalArticleBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<CreateArticleBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          onGenerateRoute: AppRoutes.onGenerateRoutes,

          home: const DailyNews(),
        );
      },
    );
  }
}