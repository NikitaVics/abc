// ignore_for_file: file_names

class CoachShowModel {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  List<String> result;

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
      result: List<String>.from(json['result']),
    );
  }
}