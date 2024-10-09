
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewList extends StatefulWidget{

  const NewList({super.key});

  @override
  State<NewList> createState() => _NewListState();
}

class Post{


 final int id;
 final String slug;
 final String url;
 final String title;
 final String content;
 final String image;
 // final String thumbnail;
 // final String status;
 // final DateTime publishedAt;
 // final DateTime updatedAt;
 // final int userId;

 Post({
   required this.id,
   required this.slug,
   required this.url,
   required this.title,
   required this.content,
   required this.image
 });



  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      slug: json['slug'],
      url: json['url'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
    );
  }
}

class _NewListState extends State<NewList>{

  List<Post> _posts = [];
  bool _isLoading = true;


  Future<void> fetchAllPosts() async{
    setState(() {_isLoading = true;});
    try{
    final response = await http.get(Uri.parse("https://jsonplaceholder.org/posts"));
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      _posts = jsonResponse.map((post) => Post.fromJson(post)).toList();
    }
    else throw Exception("Failed to load posts");
    }
    catch(exp){
      throw Exception("Failed to load posts");
    }
    finally{
    setState(() {_isLoading = false;});
  }}

  @override
  void initState(){
    fetchAllPosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Center(
          child:_isLoading ? CircularProgressIndicator() : ListView.builder(itemBuilder: (c, i){
            var _item = _posts[i];
            return ListTile(title: Text(_item.title), subtitle: Text(_item.content, overflow: TextOverflow.ellipsis,),
            leading: CircleAvatar(child: Image.network(_item.image),),);
          }),


    ));
  }


}