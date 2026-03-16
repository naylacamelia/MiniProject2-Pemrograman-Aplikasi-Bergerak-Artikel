import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article.dart';
import '../controllers/theme_controller.dart';
import 'posting_page.dart';
import 'detail_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> _allArticles = [];
  List<Article> _myArticles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  final ThemeController themeController = Get.find();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchArticles() async {
    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('articles')
          .select()
          .order('created_at', ascending: false);

      final currentUserId = Supabase.instance.client.auth.currentUser?.id;

      final all = (response as List)
          .map((item) => Article.fromMap(item))
          .toList();

      setState(() {
        _allArticles = all;
        _filteredArticles = all;
        _myArticles = all
            .where((article) => article.userId == currentUserId)
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load articles')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredArticles = _allArticles;
      } else {
        _filteredArticles = _allArticles.where((article) {
          final titleMatch = article.title.toLowerCase().contains(
            query.toLowerCase(),
          );
          final authorMatch = article.author.toLowerCase().contains(
            query.toLowerCase(),
          );
          final descMatch =
              article.desc?.toLowerCase().contains(query.toLowerCase()) ??
              false;
          return titleMatch || authorMatch || descMatch;
        }).toList();
      }
    });
  }

  Future<void> _deleteArticle(String id) async {
    try {
      await Supabase.instance.client.from('articles').delete().eq('id', id);
      _fetchArticles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete article')),
        );
      }
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            _currentIndex == 0 ? 'Discover' : 'My Blog',
            style: GoogleFonts.rubik(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: themeController.isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.sageGreenDark,
            ),
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => themeController.toggleTheme(),
              icon: Icon(
                themeController.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              tooltip: themeController.isDark ? 'Light Mode' : 'Dark Mode',
            ),
          ),
          IconButton(
            onPressed: () async {
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: Text(
                    'Sign Out',
                    style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Are you sure you want to sign out?',
                    style: GoogleFonts.rubik(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (confirm == true) _logout();
            },
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign Out',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: theme.dividerColor),
        ),
      ),

      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                await Get.to(() => const PostingPage());
                _fetchArticles();
              },
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.4),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.rubik(),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'My Blog',
          ),
        ],
      ),

      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentIndex == 0
            ? _buildExploreTab(theme)
            : _buildMyBlogTab(theme),
      ),
    );
  }

  Widget _buildExploreTab(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearch,
            style: GoogleFonts.rubik(
              fontSize: 15,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Search articles here...',
              hintStyle: GoogleFonts.rubik(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        Expanded(
          child: _filteredArticles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchController.text.isNotEmpty
                            ? Icons.search_off
                            : Icons.article_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _searchController.text.isNotEmpty
                            ? 'No results found'
                            : 'No articles yet',
                        style: GoogleFonts.rubik(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: ListView.builder(
                      itemCount: _filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = _filteredArticles[index];
                        return _buildExploreCard(article, theme);
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildExploreCard(Article article, ThemeData theme) {
    return InkWell(
      onTap: () => Get.to(() => DetailPage(article: article)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                  child: Text(
                    article.author.isNotEmpty
                        ? article.author[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.rubik(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  article.author,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  article.formattedDate,
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              article.title,
              style: GoogleFonts.rubik(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (article.desc != null && article.desc!.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                article.desc!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubik(
                  fontSize: 13,
                  height: 1.4,
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Divider(height: 1, color: theme.dividerColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMyBlogTab(ThemeData theme) {
    if (_myArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No articles yet',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to write your first article',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _myArticles.length,
          itemBuilder: (context, index) {
            final article = _myArticles[index];
            return _buildMyBlogCard(article, theme);
          },
        ),
      ),
    );
  }

  Widget _buildMyBlogCard(Article article, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.to(() => DetailPage(article: article)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.status,
                      style: GoogleFonts.rubik(
                        fontSize: 11,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    article.formattedDate,
                    style: GoogleFonts.rubik(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await Get.to(() => PostingPage(article: article));
                        _fetchArticles();
                      } else if (value == 'delete') {
                        final confirm = await Get.dialog<bool>(
                          AlertDialog(
                            title: Text(
                              'Delete article',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Are you sure wanna delete this?',
                              style: GoogleFonts.rubik(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && article.id != null) {
                          _deleteArticle(article.id!);
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: GoogleFonts.rubik(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (article.desc != null && article.desc!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  article.desc!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${article.content.split(' ').length} words',
                    style: GoogleFonts.rubik(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
