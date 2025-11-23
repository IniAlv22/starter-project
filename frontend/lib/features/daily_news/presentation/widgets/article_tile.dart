import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../domain/entities/article.dart';
import '../bloc/article/local/local_article_bloc.dart';
import '../bloc/article/local/local_article_event.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  final bool isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;

  const ArticleWidget({
    super.key,
    required this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCardStructure(context);
  }

  Widget _buildCardStructure(BuildContext context) {
    return GestureDetector(
      onTap: () => onArticlePressed?.call(article!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
        height: 230,
        decoration: _buildBackgroundImage(),
        child: Stack(
          children: [
            _buildOverlay(),
            _buildActionButton(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundImage() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      image: DecorationImage(
        image: CachedNetworkImageProvider(article!.urlToImage!),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.black.withOpacity(0.65),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Positioned(
      top: 14,
      right: 14,
      child: GestureDetector(
        onTap: () => _handleActionPressed(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isRemovable
                ? Colors.red
                : const Color.fromARGB(255, 58, 110, 255),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isRemovable ? Ionicons.trash_outline : Ionicons.bookmark_outline,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _handleActionPressed(BuildContext context) {
    if (isRemovable) {
      onRemove?.call(article!);
    } else {
      BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text('Article saved successfully.'),
        ),
      );
    }
  }

  Widget _buildContent() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 12),
          _buildAuthorAndDate(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      article!.title ?? "",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Muli',
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    );
  }

  Widget _buildAuthorAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Autor ${article!.author ?? 'Unknown'}",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        Text(
          article!.publishedAt ?? "",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}