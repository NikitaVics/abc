class ProfileModel {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  final Profile result;

  ProfileModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: Profile.fromJson(json['result']),
    );
  }
}

class Profile {
  final String imageUrl;
  final String name;
  final String phoneNumber;

  Profile({
    required this.imageUrl,
    required this.name,
    required this.phoneNumber,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      imageUrl: json['imageUrl'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
