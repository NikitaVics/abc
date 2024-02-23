class RepeatCoach {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  FriendsModel result;

  RepeatCoach({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory RepeatCoach.fromJson(Map<String, dynamic> json) {
    return RepeatCoach(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: FriendsModel.fromJson(json['result']),
    );
  }
}

class FriendsModel {
  final int id;
  final String imageUrl;
  final bool isAvailable;

  FriendsModel({required this.id, required this.imageUrl , required this.isAvailable, });

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    return FriendsModel(
      id: json['memberId'],
      imageUrl: json['memberImage'],
      isAvailable: json['isAvailable'],
    );
  }
}
