import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostingPage extends StatefulWidget {
  final Article? article;

  const PostingPage({super.key, this.article});

  @override
  State<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _contentController = TextEditingController();
  String _authorName = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _contentController.text = widget.article!.content;
      _descController.text = widget.article!.desc ?? '';
      _authorName = widget.article!.author;
    } else {
      _loadAuthorName();
    }
  }

  Future<void> _loadAuthorName() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    print('Current user ID: $userId'); // ← tambah ini

    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('profiles')
        .select('display_name')
        .eq('id', userId)
        .single();

    print('Profile response: $response'); // ← dan ini

    setState(() {
      _authorName = response['display_name'] ?? '';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String? _validateFields() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      return 'Please fill all fields';
    }
    if (_titleController.text.trim().isEmpty) {
      return 'Title cannot be empty';
    }
    if (_contentController.text.trim().isEmpty) {
      return 'Content cannot be empty';
    }
    return null;
  }

  Future<void> _saveArticle() async {
    final error = _validateFields();
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      if (widget.article == null) {
        await Supabase.instance.client.from('articles').insert({
          'title': _titleController.text.trim(),
          'description': _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          'content': _contentController.text.trim(),
          'author': _authorName,
          'user_id': userId,
        });
      } else {
        await Supabase.instance.client
            .from('articles')
            .update({
              'title': _titleController.text.trim(),
              'description': _descController.text.trim().isEmpty
                  ? null
                  : _descController.text.trim(),
              'content': _contentController.text.trim(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', widget.article!.id!);
      }

      Get.back();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save article')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _onWillPop() async {
    final isEmpty =
        _titleController.text.isEmpty &&
        _descController.text.isEmpty &&
        _contentController.text.isEmpty;

    if (isEmpty) return true;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Wanna go back?',
          style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Your draft will not be saved.',
          style: GoogleFonts.rubik(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.article != null;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop) Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop) Get.back();
            },
          ),
          title: Text(
            'Back',
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: theme.dividerColor),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveArticle,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEdit ? 'Update' : 'Publish',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
        body: Theme(
          data: theme.copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        style: GoogleFonts.rubik(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add Title',
                          hintStyle: GoogleFonts.rubik(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      TextField(
                        controller: _descController,
                        style: GoogleFonts.rubik(
                          fontSize: 18,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add description...',
                          hintStyle: GoogleFonts.rubik(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: theme.colorScheme.primary,
                            child: const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _authorName.isEmpty ? 'Loading...' : _authorName,
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 40, color: theme.dividerColor),
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          height: 1.8,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write here...',
                          hintStyle: GoogleFonts.merriweather(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
