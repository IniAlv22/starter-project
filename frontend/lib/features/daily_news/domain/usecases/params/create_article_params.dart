class CreateArticleParams {
  final String title;
  final String description;
  final String? imagePath;

  const CreateArticleParams({
    required this.title,
    required this.description,
    this.imagePath,
  });
}
