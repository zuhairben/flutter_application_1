import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListElement extends StatefulWidget {
  const ListElement({ super.key });

  

  @override
  State<ListElement> createState() => _ListElementState();
}

class _ListElementState extends State<ListElement> {
  Future<List<Post>> fetchAllPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.org/posts'));
    
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    }
    else{
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(future: fetchAllPosts(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(itemBuilder: (context, index){
              return Card(
                key: ValueKey(index),
                child: ListTile(
                  leading: Image.network(snapshot.data![index].image),
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].content, overflow: TextOverflow.ellipsis,),
                ),
              );
            });
          }
          else if(snapshot.hasError){
            return Text('error fetch');
          }
          return Center(child: CircularProgressIndicator());
        }),
      );
  }
}



class Post{
  final int id;
  final String slug;
  final String url;
  final String title;
  final String content;
  final String image;

  Post({
  required this.id,
  required this.slug,
  required this.url,
  required this.title,
  required this.content,
  required this.image

  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(id: json['id'], slug: json['slug'], url: json['url'], title: json['title'], content: json['content'], image: json['image']);
  }
}





