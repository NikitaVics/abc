class SearchModel {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  List<Profile> result;

  SearchModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: List<Profile>.from(
        (json['result'] as List<dynamic>? ?? [])
            .map((item) => Profile.fromJson(item))
            .toList(),
      ),
    );
  }
}

class Profile {
  final String imageUrl;
  final String name;
  final int id;
  final bool friendRequest;

  Profile({
    required this.imageUrl,
    required this.name,
    required this.id,
    required this.friendRequest,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      imageUrl: json['image'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      friendRequest: json['isFriendRequestSentOrReceived'],
    );
  }
}
