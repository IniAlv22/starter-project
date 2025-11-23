import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/article.dart';

class FirestoreArticleService {
  final FirebaseFirestore firestore;

  FirestoreArticleService(this.firestore);

  CollectionReference get _articlesRef =>
      firestore.collection("articles");

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
}
