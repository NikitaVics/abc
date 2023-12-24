class FriendShowModel {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  List<Friend> result;
 

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
       result: List<Friend>.from(json['result'].map((friendJson) =>Friend.fromJson(friendJson))),
    );
  }
}
class Friend {
  final int id;
  final String imageUrl;

  Friend({required this.id, required this.imageUrl});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      imageUrl: json['imageUrl'],
    );
  }
}

