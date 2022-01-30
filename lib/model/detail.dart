class Detail{
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Detail({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}