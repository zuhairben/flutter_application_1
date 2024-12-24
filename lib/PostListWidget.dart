import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post/Post.dart';
import 'package:post/PostList.dart';
import 'package:provider/provider.dart';

class PostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Post> posts = context.watch<PostList>().posts;

    if (context.watch<PostList>().listSize == 0) {
      context.read<PostList>().getPosts();
    }
    return context.watch<PostList>().listSize == 0
        ? const CircularProgressIndicator()
        : ListView.builder(itemBuilder: (context, index) {
            return Card(
              key: ValueKey(index),
              child: ListTile(
                leading: Image.network(posts[index].image),
                title: Text(posts[index].title),
                subtitle: Text(
                  posts[index].content,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          });
  }
}
