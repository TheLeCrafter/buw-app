class Post {
  final String title;
  final String imageUrl;
  final String text;

  Post({required this.title, required this.imageUrl, required this.text});

  factory Post.fromJson(Map<String, dynamic> json) {
    String _title = json["title"];
    _title = _title.replaceAll("\$", "");
    String _imageUrl = json["thumbnail_url"];
    _imageUrl = _imageUrl.replaceAll("\$", "");
    String _text = json["text"];
    _text = _text.replaceAll("\$", "");
    return Post(title: _title, imageUrl: _imageUrl, text: _text);
  }
}