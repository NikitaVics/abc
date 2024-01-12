class AllFrinedRequestModel {
  int statusCode;
  bool isSuccess;
  List<dynamic> errorMessage;
  List<MyFriendRequest> result;

  AllFrinedRequestModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory AllFrinedRequestModel.fromJson(Map<String, dynamic> json) {
    return AllFrinedRequestModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'] ?? [],
      result: List<MyFriendRequest>.from(
        (json['result'] as List<dynamic>? ?? [])
            .map((item) => MyFriendRequest.fromJson(item))
            .toList(),
      ),
    );
  }
}
class MyFriendRequest {
  final int friendId;
  final String friendName;
  final String friendImageUrl;

  MyFriendRequest({
    required this.friendId,
    required this.friendName,
    required this.friendImageUrl,
  });

  factory MyFriendRequest.fromJson(Map<String, dynamic> json) {
    return MyFriendRequest(
      friendId: json['id'],
      friendName: json['userName'],
      friendImageUrl: json['imageUrl'],
    );
  }
}
