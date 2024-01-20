class UpcomingBookingModel {
  int statusCode;
  bool isSuccess;
  List<dynamic> errorMessage;
  List<Booking> result;

  UpcomingBookingModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory UpcomingBookingModel.fromJson(Map<String, dynamic> json) {
    return UpcomingBookingModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'] ?? [],
      result: List<Booking>.from(
        (json['result'] as List<dynamic>? ?? [])
            .map((item) => Booking.fromJson(item))
            .toList(),
      ),
    );
  }
}

class Booking {
  int bookingId;
  DateTime? bookingDate;
  int slotId;
  String? slot;
  Tenis tennisCourt;
  int coachId;
  String? coachName;
  String? coachImage;
  int teamId;
  List<TeamMember> teamMembers;
  int userId;
  String? userName;
  String? userImage;

  Booking({
    required this.bookingId,
    required this.bookingDate,
    required this.slotId,
    required this.slot,
    required this.tennisCourt,
    required this.coachId,
    required this.coachName,
    required this.coachImage,
    required this.teamId,
    required this.teamMembers,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'] ?? 0,
      bookingDate: json['bookingDate'] != null
          ? DateTime.parse(json['bookingDate'])
          : null,
      slotId: json['slotId'] ?? 0,
      slot: json['slot'],
      tennisCourt: Tenis.fromJson(json["tennisCourt"]),
      coachId: json['coachId'] ?? 0,
      coachName: json['coachName'],
      coachImage: json['coachImage'],
      teamId: json['teamId'] ?? 0,
      teamMembers: List<TeamMember>.from(
        (json['teamMembers'] as List<dynamic>? ?? [])
            .map((item) => TeamMember.fromJson(item))
            .toList(),
      ),
      userId: json['userId'] ?? 0,
      userName: json['userName'],
      userImage: json['userImage'],
    );
  }
}

class TeamMember {
  int id;
  String imageUrl;
  String name;

  TeamMember({
    required this.id,
    required this.imageUrl,
    required this.name,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? 0,
      imageUrl: json['imageUrl']??'',
      name: json['name'],
    );
  }
}
class Tenis {
  int id;
  
  String name;
   List<String> courtImageURLs;

  Tenis({
    required this.id,
    required this.courtImageURLs,
    required this.name,
  });

  factory Tenis.fromJson(Map<String, dynamic> json) {
    return Tenis(
      id: json['id'] ?? 0,
courtImageURLs: (json['courtImages'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      name: json['name'],
    );
  }
}
