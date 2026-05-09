import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../theme/app_theme.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  final int depth;

  const CommentTile({
    super.key,
    required this.comment,
    this.depth = 0,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _isCollapsed = false;

  String _parseHtml(String html) {
    return html
        .replaceAll(RegExp(r'<p>'), '\n\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&gt;', '>')
        .replaceAll('&lt;', '<')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .trim();
  }

  Color get _depthColor {
    const colors = [
      AppTheme.neonGreen,
      Color(0xFF00BFFF),
      Color(0xFFFF6EC7),
      Color(0xFFFFD700),
    ];
    return colors[widget.depth % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.depth * 12.0 + 8,
        right: 8,
        top: 5,
        bottom: 2,
      ),
      // Row to manually draw left border without borderRadius conflict
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left colored bar - separate container, no borderRadius issue
            Container(
              width: 2,
              decoration: BoxDecoration(
                color: _depthColor.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),

            // Comment content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D0D),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  // Uniform border - same color all sides, no conflict
                  border: Border.all(
                    color: _depthColor.withOpacity(0.12),
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header - tap to collapse
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isCollapsed = !_isCollapsed),
                      child: Row(
                        children: [
                          Text(
                            widget.comment.by,
                            style: TextStyle(
                              color: _depthColor,
                              fontSize: 11,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: _depthColor.withOpacity(0.6),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.comment.timeAgo,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _isCollapsed ? '[+]' : '[-]',
                            style: TextStyle(
                              color: _depthColor.withOpacity(0.5),
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Comment body
                    if (!_isCollapsed) ...[
                      const SizedBox(height: 6),
                      Text(
                        _parseHtml(widget.comment.text),
                        style: const TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontSize: 12,
                          height: 1.55,
                          fontFamily: 'monospace',
                        ),
                      ),

                      // Nested children
                      if (widget.comment.children.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        ...widget.comment.children.map(
                          (child) => CommentTile(
                            comment: child,
                            depth: widget.depth + 1,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}