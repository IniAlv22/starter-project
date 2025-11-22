import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_symmetry/config/routes/routes.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_symmetry/features/daily_news/presentation/pages/home/daily_news.dart';
import 'config/theme/app_themes.dart';
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
  print("FIRESTORE HOST: ${FirebaseFirestore.instance.settings.host}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      onGenerateRoute: AppRoutes.onGenerateRoutes,

      // 👇 ESTA ES LA DIFERENCIA CRÍTICA
      home: BlocProvider<RemoteArticlesBloc>(
        create: (context) =>
            sl<RemoteArticlesBloc>()..add(const GetArticles()),
        child: const DailyNews(),
      ),
    );
  }
}