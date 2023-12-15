class FriendShowModel {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  List<String> result;

  FriendShowModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory FriendShowModel.fromJson(Map<String, dynamic> json) {
    return FriendShowModel(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: List<String>.from(json['result']),
    );
  }
}
