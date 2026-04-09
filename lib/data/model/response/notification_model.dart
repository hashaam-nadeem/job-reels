
class NotificationModel {
  int id;
  String type;
  String title;
  String notification;
  int userId;
  int postId;
  String date;
  String time;


  NotificationModel({
    required this.id,
    required this.title,
    required this.type,
    required this.notification,
    required this.userId,
    required this.postId,
    required this.date,
    required this.time,
  });

  factory NotificationModel.fromLocalJson(json) {
    return NotificationModel(
      id: json['id'],
      title: json['title']??"",
      type: json['type']??"",
      notification: json['notification'],
      userId: json['user_id'],
      postId: json['post_id'],
      date: json['date'],
      time: json['time']??"",
    );
  }
}