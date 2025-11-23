import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_symmetry/config/theme/theme_cubit.dart';

import '../../widgets/symmetry_app_bar.dart';
import '../../widgets/symmetry_footer.dart';

import '../../bloc/article/create/create_article_bloc.dart';
import '../../bloc/article/create/create_article_event.dart';
import '../../bloc/article/create/create_article_state.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          _buildSectionHeader(context),
          _buildContent(context),
          const SymmetryFooter(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SymmetryAppBar(
      isDarkMode: context.watch<ThemeCubit>().state,
      onToggleTheme: () => context.read<ThemeCubit>().toggleTheme(),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final bool isDarkMode = context.watch<ThemeCubit>().state;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _onBackButtonTapped(context),
                child: Icon(
                  Icons.chevron_left,
                  size: 28,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Create article",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () => _submit(context),
            child: Icon(
              Icons.save,
              size: 24,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bool isDark = context.watch<ThemeCubit>().state;

    return Expanded(
      child: BlocListener<CreateArticleBloc, CreateArticleState>(
        listener: (context, state) {
          if (state is CreateArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Article created successfully!")),
            );
            Navigator.pop(context);
          }
          if (state is CreateArticleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInput(
                  label: "Title",
                  controller: _titleCtrl,
                  isDark: isDark,
                ),
                _buildInput(
                  label: "Author",
                  controller: _authorCtrl,
                  isDark: isDark,
                ),
                _buildTextArea(
                  label: "Description",
                  controller: _descCtrl,
                  isDark: isDark,
                ),
                _buildImagePicker(isDark),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.white38 : Colors.black45,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required String label,
    required TextEditingController controller,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        maxLines: 6,
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.white38 : Colors.black45,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Image",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picker = ImagePicker();
            final picked =
                await picker.pickImage(source: ImageSource.gallery);

            if (picked != null) {
              setState(() {
                _selectedImagePath = picked.path;
              });
            }
          },
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedImagePath == null
                ? Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: isDark ? Colors.white54 : Colors.black54,
                      size: 42,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_selectedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<CreateArticleBloc>().add(
          SubmitArticleEvent(
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            imagePath: _selectedImagePath, // <-- REAL FILE PATH
          ),
        );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }
}