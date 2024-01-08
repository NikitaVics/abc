
class AllFrinedModel {
  int statusCode;
  bool isSuccess;
  List<dynamic> errorMessage;
  List<MyFriend> result;

  AllFrinedModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory AllFrinedModel.fromJson(Map<String, dynamic> json) {
    return AllFrinedModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'] ?? [],
      result: List<MyFriend>.from(
        (json['result'] as List<dynamic>? ?? [])
            .map((item) => MyFriend.fromJson(item))
            .toList(),
      ),
    );
  }
}
class MyFriend {
  final int friendId;
  final String friendName;
  final String friendImageUrl;

  MyFriend({
    required this.friendId,
    required this.friendName,
    required this.friendImageUrl,
  });

  factory MyFriend.fromJson(Map<String, dynamic> json) {
    return MyFriend(
      friendId: json['friendId'],
      friendName: json['friendName'],
      friendImageUrl: json['friendImageUrl'],
    );
  }
}
