import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/comment.dart';
import '../models/story.dart';
import '../services/hn_api.dart';
import '../theme/app_theme.dart';
import '../widgets/comment_tile.dart';

class DetailScreen extends StatefulWidget {
  final Story story;

  const DetailScreen({super.key, required this.story});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final comments = await HnApi.fetchNestedComments(widget.story.kids);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _openUrl() async {
    if (widget.story.url == null) return;
    final uri = Uri.parse(widget.story.url!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppTheme.neonGreen,
          size: 18,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '[ STORY ]',
        style: AppTheme.neonText(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (widget.story.url != null)
          IconButton(
            onPressed: _openUrl,
            icon: const Icon(
              Icons.open_in_browser,
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildStoryHeader()),
        SliverToBoxAdapter(child: _buildCommentsLabel()),
        if (_isLoading)
          const SliverToBoxAdapter(child: _CommentsLoadingWidget())
        else if (_hasError)
          SliverToBoxAdapter(child: _buildErrorWidget())
        else if (_comments.isEmpty)
          SliverToBoxAdapter(child: _buildNoCommentsWidget())
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CommentTile(
                comment: _comments[index],
                depth: 0,
              ),
              childCount: _comments.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildStoryHeader() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: AppTheme.cardWithAccent(accentColor: AppTheme.hnOrange),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left orange accent bar
            Container(
              width: 3,
              decoration: const BoxDecoration(
                color: AppTheme.hnOrange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.story.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        fontFamily: 'monospace',
                      ),
                    ),

                    // Domain link
                    if (widget.story.domain != null) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _openUrl,
                        child: Text(
                          '> ${widget.story.domain}',
                          style: const TextStyle(
                            color: AppTheme.hnOrange,
                            fontSize: 11,
                            fontFamily: 'monospace',
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.hnOrange,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.neonGreen.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Meta
                    Wrap(
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        _MetaItem(
                          label: '▲ ${widget.story.score} pts',
                          color: AppTheme.hnOrange,
                        ),
                        _MetaItem(
                          label: '⬡ ${widget.story.by}',
                          color: AppTheme.neonGreen,
                        ),
                        _MetaItem(
                          label: '⏱ ${widget.story.timeAgo}',
                          color: AppTheme.textSecondary,
                        ),
                        _MetaItem(
                          label: '💬 ${widget.story.commentCount} comments',
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      child: Row(
        children: [
          Text(
            '// COMMENTS',
            style: AppTheme.neonText(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.neonGreen.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.neonGreen.withOpacity(0.4),
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              'FAILED TO LOAD COMMENTS',
              style: AppTheme.neonText(fontSize: 12),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _loadComments,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: AppTheme.glassDecoration(),
                child: Text(
                  '[ RETRY ]',
                  style: AppTheme.neonText(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCommentsWidget() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(
          '// NO COMMENTS YET',
          style: AppTheme.neonText(fontSize: 12),
        ),
      ),
    );
  }
}

class _CommentsLoadingWidget extends StatelessWidget {
  const _CommentsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.neonGreen,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'LOADING COMMENTS...',
            style: AppTheme.neonText(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// Reusable meta info item
class _MetaItem extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontFamily: 'monospace',
      ),
    );
  }
}