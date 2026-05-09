import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';
import '../models/comment.dart';

class HnApi {
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  static const int _storiesLimit = 30;

  static Future<List<int>> fetchTopStoryIds() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/topstories.json'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> ids = jsonDecode(response.body);
      return ids.take(_storiesLimit).cast<int>().toList();
    } else {
      throw Exception('Failed to load story IDs');
    }
  }

  static Future<Story> fetchStory(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/item/$id.json'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Story.fromJson(json);
    } else {
      throw Exception('Failed to load story $id');
    }
  }

  static Future<List<Story>> fetchTopStories() async {
    final ids = await fetchTopStoryIds();
    final futures = ids.map((id) => fetchStory(id));
    final stories = await Future.wait(futures);
    return stories;
  }

  static Future<Comment?> fetchComment(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/item/$id.json'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final comment = Comment.fromJson(json);
        if (!comment.isValid) return null;
        return comment;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Comment>> fetchComments(List<int> kidIds) async {
    if (kidIds.isEmpty) return [];
    final limitedIds = kidIds.take(20).toList();
    final futures = limitedIds.map((id) => fetchComment(id));
    final results = await Future.wait(futures);
    return results.whereType<Comment>().toList();
  }

  static Future<List<Comment>> fetchNestedComments(
    List<int> kidIds, {
    int depth = 0,
    int maxDepth = 2,
  }) async {
    if (kidIds.isEmpty || depth >= maxDepth) return [];
    final limitedIds = kidIds.take(5).toList();
    final futures = limitedIds.map((id) async {
      final comment = await fetchComment(id);
      if (comment == null) return null;
      if (comment.kids.isNotEmpty && depth < maxDepth) {
        comment.children = await fetchNestedComments(
          comment.kids,
          depth: depth + 1,
          maxDepth: maxDepth,
        );
      }
      return comment;
    });
    final results = await Future.wait(futures);
    return results.whereType<Comment>().toList();
  }
}