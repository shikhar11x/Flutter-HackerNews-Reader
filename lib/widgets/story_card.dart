import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final int index;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: AppTheme.cardWithAccent(),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left neon accent bar
              Container(
                width: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.neonGreen,
                      AppTheme.neonGreen.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),

              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Index + Title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index.toString().padLeft(2, '0')}.',
                            style: TextStyle(
                              color: AppTheme.neonGreen.withOpacity(0.5),
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              story.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.45,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Domain
                      if (story.domain != null) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 26),
                          child: Text(
                            '(${story.domain})',
                            style: TextStyle(
                              color: AppTheme.textSecondary.withOpacity(0.8),
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Meta info
                      Padding(
                        padding: const EdgeInsets.only(left: 26),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            _MetaItem(
                              label: '▲ ${story.score}',
                              color: AppTheme.hnOrange,
                            ),
                            _MetaItem(
                              label: '⬡ ${story.by}',
                              color: AppTheme.neonGreenDim,
                            ),
                            _MetaItem(
                              label: '⏱ ${story.timeAgo}',
                              color: AppTheme.textSecondary,
                            ),
                            _MetaItem(
                              label: '💬 ${story.commentCount}',
                              color: AppTheme.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        fontSize: 10,
        fontFamily: 'monospace',
      ),
    );
  }
}