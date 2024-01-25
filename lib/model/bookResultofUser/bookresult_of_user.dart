class BookedResultOfUser {
  final int statusCode;
  final bool isSuccess;
  final List<dynamic> errorMessage;
  final BookedResult result;

  BookedResultOfUser({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory BookedResultOfUser.fromJson(Map<String, dynamic> json) {
    return BookedResultOfUser(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: List<dynamic>.from(json['errorMessage'] ?? []),
      result: BookedResult.fromJson(json['result'] ?? {}),
    );
  }
}

class BookedResult {
  final int bookingId;
  final DateTime bookingDate;
  final int slotId;
  final String slot;
  final TennisCourt tennisCourt;
  final int coachId;
  final String coachName;
  final dynamic coachImage;
  final int teamId;
  final List<TeamMember> teamMembers;
  final int userId;
  final String userName;
  final String userImage;

  BookedResult({
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

  factory BookedResult.fromJson(Map<String, dynamic> json) {
    return BookedResult(
      bookingId: json['bookingId'] ?? 0,
      bookingDate: DateTime.parse(json['bookingDate'] ?? ''),
      slotId: json['slotId'] ?? 0,
      slot: json['slot'] ?? '',
      tennisCourt: TennisCourt.fromJson(json['tennisCourt']),
      coachId: json['coachId'] ?? 0,
      coachName: json['coachName'] ?? '',
      coachImage: json['coachImage'],
      teamId: json['teamId'] ?? 0,
      teamMembers: List<TeamMember>.from(
        (json['teamMembers'] as List<dynamic>? ?? [])
            .map((item) => TeamMember.fromJson(item))
            .toList(),
      ),
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      userImage: json['userImage'] ?? '',
    );
  }
}

class TennisCourt {
  final int id;
  final String name;
  final List<String> courtImages;

  TennisCourt({
    required this.id,
    required this.name,
    required this.courtImages,
  });

  factory TennisCourt.fromJson(Map<String, dynamic> json) {
    return TennisCourt(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
     courtImages: (json['courtImages'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }
}

class CourtImage {
  final int id;
  final String imageUrl;

  CourtImage({
    required this.id,
    required this.imageUrl,
  });

  factory CourtImage.fromJson(Map<String, dynamic> json) {
    return CourtImage(
      id: json['id'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class TeamMember {
  final int id;
  final String imageUrl;
  final dynamic name;

  TeamMember({
    required this.id,
    required this.imageUrl,
    required this.name,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'],
    );
  }
}