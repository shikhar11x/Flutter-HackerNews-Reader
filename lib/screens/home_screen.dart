import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/hn_api.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/story_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Story> _stories = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final stories = await HnApi.fetchTopStories();
      setState(() {
        _stories = stories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _openStory(Story story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(story: story),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surface,
      elevation: 0,
      title: Row(
        children: [
          // Terminal style HN logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.neonGreen.withOpacity(0.6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.neonGreen.withOpacity(0.08),
            ),
            child: Text(
              'HN',
              style: TextStyle(
                color: AppTheme.neonGreen,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                fontFamily: 'monospace',
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: AppTheme.neonGreen.withOpacity(0.9),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Title with blinking cursor
          Row(
            children: [
              Text(
                'Hacker News',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 4),
              _BlinkingCursor(),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _isLoading ? null : _loadStories,
          icon: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.neonGreen,
                  ),
                )
              : const Icon(
                  Icons.refresh,
                  color: AppTheme.neonGreen,
                  size: 20,
                ),
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.neonGreen.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const LoadingShimmer();
    if (_hasError) return _buildErrorWidget();
    if (_stories.isEmpty) return _buildEmptyWidget();

    return Column(
      children: [
        // Terminal status bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          color: const Color(0xFF0D1A0D),
          child: Text(
            '▸ TOP STORIES // ${_stories.length} LOADED',
            style: TextStyle(
              color: AppTheme.neonGreen.withOpacity(0.5),
              fontSize: 10,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
        ),

        // Stories list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadStories,
            color: AppTheme.neonGreen,
            backgroundColor: AppTheme.surface,
            child: ListView.builder(
              itemCount: _stories.length,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemBuilder: (context, index) {
                return StoryCard(
                  story: _stories[index],
                  index: index + 1,
                  onTap: () => _openStory(_stories[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 44,
            color: AppTheme.neonGreen.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'CONNECTION FAILED',
            style: AppTheme.neonText(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _loadStories,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              decoration: AppTheme.glassDecoration(),
              child: Text(
                '[ RETRY ]',
                style: AppTheme.neonText(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Text(
        '// NO STORIES FOUND',
        style: AppTheme.neonText(fontSize: 14),
      ),
    );
  }
}

// Blinking terminal cursor animation
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Text(
            '█',
            style: TextStyle(
              color: AppTheme.neonGreen,
              fontSize: 13,
              shadows: [
                Shadow(
                  color: AppTheme.neonGreen.withOpacity(0.9),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}