abstract class CreateArticleEvent {}

class SubmitArticleEvent extends CreateArticleEvent {
  final String title;
  final String description;
  final String? imagePath;

  SubmitArticleEvent({
    required this.title,
    required this.description,
    this.imagePath,
  });
}