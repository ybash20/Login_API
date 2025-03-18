class Post {
  int? id;
  String? title;

  Post({
    this.id,
    this.title,
  });

  factory Post.fromjson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
    );
  }
}
