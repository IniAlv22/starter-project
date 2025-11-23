import 'package:floor/floor.dart';
import '../../domain/entities/article.dart';

@Entity(tableName: "article")
class ArticleModel extends ArticleEntity {

  @primaryKey
  final int? id;

  const ArticleModel({
    required this.id,
    required super.author,
    required super.title,
    required super.description,
    required super.url,
    required super.urlToImage,
    required super.publishedAt,
    required super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json["id"],
      author: json["author"],
      title: json["title"],
      description: json["description"],
      url: json["url"],
      urlToImage: json["urlToImage"],
      publishedAt: json["publishedAt"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };

  factory ArticleModel.fromEntity(ArticleEntity e) {
    return ArticleModel(
      id: e.id,
      author: e.author,
      title: e.title,
      description: e.description,
      url: e.url,
      urlToImage: e.urlToImage,
      publishedAt: e.publishedAt,
      content: e.content,
    );
  }
}