class RepeatFriend {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  List<FriendsModel> result;

  RepeatFriend({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory RepeatFriend.fromJson(Map<String, dynamic> json) {
    return RepeatFriend(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: List<FriendsModel>.from(json['result']
          .map((friendJson) => FriendsModel.fromJson(friendJson))),
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
