class MyProfile {
  late int statusCode;
  late bool isSuccess;
  late List<String> errorMessage;
  late ProfileResult result;

  MyProfile({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    return MyProfile(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: ProfileResult.fromJson(json['result']),
    );
  }
}

class ProfileResult {
  late String name;
  late String userName;
  late String phoneNumber;
  late String gender;
  late int totalBookings;
  late int totalCancelledBookings;

  ProfileResult({
    required this.name,
    required this.userName,
    required this.phoneNumber,
    required this.gender,
    required this.totalBookings,
    required this.totalCancelledBookings,
  });

  factory ProfileResult.fromJson(Map<String, dynamic> json) {
    return ProfileResult(
      name: json['name'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      totalBookings: json['totalBookings'],
      totalCancelledBookings: json['totalCancelledBookings'],
    );
  }
}
