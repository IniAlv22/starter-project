import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_symmetry/features/daily_news/domain/usecases/params/create_article_params.dart';
import '../../models/article.dart';

class FirestoreArticleService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreArticleService(this._firestore, this._storage,);

  CollectionReference get _articlesRef =>
      _firestore.collection("articles");

  Future<List<ArticleModel>> getArticles() async {
    final query = await _articlesRef.get();
    return query.docs
        .map((doc) => ArticleModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveArticle(ArticleModel article) async {
    final doc = _articlesRef.doc();  
    await doc.set(article.toJson());
  }

  Future<void> removeArticle( id) async {
    await _articlesRef.doc(id).delete();
  }

  Future<void> createArticle(CreateArticleParams params) async {
    String? imageUrl;

    if (params.imagePath != null) {
      final ref = _storage.ref().child(
        "articles/${DateTime.now().microsecondsSinceEpoch}.jpg",
      );
      await ref.putFile(File(params.imagePath!));
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection("articles").add({
      "title": params.title,
      "description": params.description,
      "urlToImage": imageUrl,
      "publishedAt": DateTime.now().toIso8601String(),
    });
  }

}
