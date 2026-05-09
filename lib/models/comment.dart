class Comment {
  final int id;
  final String by;
  final String text;
  final int time;
  final List<int> kids;
  final bool deleted;
  final bool dead;
  List<Comment> children;

  Comment({
    required this.id,
    required this.by,
    required this.text,
    required this.time,
    required this.kids,
    required this.deleted,
    required this.dead,
    this.children = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      by: json['by'] ?? 'unknown',
      text: json['text'] ?? '',
      time: json['time'] ?? 0,
      kids: List<int>.from(json['kids'] ?? []),
      deleted: json['deleted'] ?? false,
      dead: json['dead'] ?? false,
    );
  }

  String get timeAgo {
    final commentTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    final difference = DateTime.now().difference(commentTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'just now';
  }

  bool get isValid => !deleted && !dead && text.isNotEmpty;
}