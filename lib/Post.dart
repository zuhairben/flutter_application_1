class Post {
  final int id;
  final String slug;
  final String url;
  final String title;
  final String content;
  final String image;

  Post(
      {required this.id,
      required this.slug,
      required this.url,
      required this.title,
      required this.content,
      required this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      slug: json["slug"],
      url: json["url"],
      title: json["title"],
      content: json["content"],
      image: json["image"],
    );
  }
}
