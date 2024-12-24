import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:post/Post.dart';
import 'package:http/http.dart' as http;

class PostList extends ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;
  int get listSize => _posts.length;

  void getPosts() async {
    try {
      final response =
          await http.get(Uri.parse("https://jsonplaceholder.org/posts"));

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        _posts = jsonResponse.map((post) => Post.fromJson(post)).toList();
      }
    } catch (e) {
      throw Exception("Error loading posts");
    }
    notifyListeners();
  }
}
