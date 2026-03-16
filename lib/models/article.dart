class Article {
  final String? id;
  String title;
  String? desc;
  String author;
  String content;
  String status;
  final String? userId;
  final DateTime date;

  Article({
    this.id,
    required this.title,
    this.desc,
    required this.author,
    required this.content,
    this.status = 'published',
    this.userId,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as String?,
      title: map['title'] as String,
      desc: map['description'] as String?,
      author: map['author'] as String,
      content: map['content'] as String,
      status: map['status'] as String? ?? 'published',
      userId: map['user_id'] as String?,
      date: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
