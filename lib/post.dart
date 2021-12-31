class Post {
  final String title;
  final String imageUrl;
  final String text;

  Post({required this.title, required this.imageUrl, required this.text});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(title: json["title"], imageUrl: json["thumbnail_url"], text: json["text"]);
  }
}