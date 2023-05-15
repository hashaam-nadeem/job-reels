class Task{
  final int id;
  final String content;
  final int status;
  final String ?date;
  final String ?time;
  final String ?day;

  Task({
    required this.id,
    required this.content,
    required this.status,
    this.date,
    this.time,
    this.day,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id : json['id'] ?? 0,
      content : json['content']??"",
      status : json['status']??0,
      date: json['date'],
      time: json['time'],
      day: json['day'],
    );
  }
}