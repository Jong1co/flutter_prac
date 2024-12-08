class Todo {
  int? id;
  String title;
  String content;
  String createdAt;
  bool isDone;

  Todo({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isDone,
  });
}
