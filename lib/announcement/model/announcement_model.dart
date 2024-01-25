class AnnouncementModel {
  int statusCode;
  bool isSuccess;
  List<dynamic> errorMessage;
  List<Announcement> result;

  AnnouncementModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return  AnnouncementModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'] ?? [],
      result: List<Announcement>.from(
        (json['result'] as List<dynamic>? ?? [])
            .map((item) => Announcement.fromJson(item))
            .toList(),
      ),
    );
  }
}
class Announcement {
   final int id;
  final String announcementType;
  final String message;
  final String scheduledDate;
  final String scheduledTime;
  final List<String> imageUrl;

  Announcement({
     required this.id,
    required this.announcementType,
    required this.message,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.imageUrl,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
     id: json['id'] ?? 0,
    announcementType: json['announcementType'] ?? '',
    message: json['message'] ?? '',
    scheduledDate: json['scheduledDate'] ?? '',
    scheduledTime: json['scheduledTime'] ?? '',
    imageUrl: List<String>.from(json['imageUrl'] ?? []),
    );
  }
}
