// ignore_for_file: file_names

class CoachShowModel {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  List<Coach> result; // Updated type here

  CoachShowModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory CoachShowModel.fromJson(Map<String, dynamic> json) {
    return CoachShowModel(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: List<Coach>.from(json['result'].map((coachJson) => Coach.fromJson(coachJson))),
    );
  }
}

class Coach {
  final int coachId;
  final String imageUrl;

  Coach({required this.coachId, required this.imageUrl});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      coachId: json['coachId'],
      imageUrl: json['imageUrl'],
    );
  }
}
