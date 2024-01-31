class NotificationModel {
  int statusCode;
  bool isSuccess;
  List<dynamic> errorMessage;
  List<Notifications> result;

  NotificationModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory  NotificationModel.fromJson(Map<String, dynamic> json) {
    return  NotificationModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'] ?? [],
      result: List<Notifications>.from(
        (json['result'] as List<dynamic>? ?? [])
            .map((item) => Notifications.fromJson(item))
            .toList(),
      ),
    );
  }
}
class Notifications {
  final int id;
  final int userId;
  final String title;
  final String notificationBody;
  final String creationDate;
  final String? imageUrl;

 Notifications({
     required this.id,
    required this.userId,
    required this.title,
    required this.notificationBody,
    required this.creationDate,
    this.imageUrl,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
     id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      notificationBody: json['notificationBody'] as String,
      creationDate: json['creationDate'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
