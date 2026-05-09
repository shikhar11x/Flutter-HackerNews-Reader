class Story {
  final int id;
  final String title;
  final String? url;
  final String by;
  final int score;
  final int time;
  final int commentCount;
  final List<int> kids;

  Story({
    required this.id,
    required this.title,
    this.url,
    required this.by,
    required this.score,
    required this.time,
    required this.commentCount,
    required this.kids,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      url: json['url'],
      by: json['by'] ?? 'unknown',
      score: json['score'] ?? 0,
      time: json['time'] ?? 0,
      commentCount: json['descendants'] ?? 0,
      kids: List<int>.from(json['kids'] ?? []),
    );
  }

  String get timeAgo {
    final storyTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    final difference = DateTime.now().difference(storyTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'just now';
  }

  String? get domain {
    if (url == null) return null;
    try {
      final uri = Uri.parse(url!);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return null;
    }
  }
}