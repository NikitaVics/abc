class ProfileCreateTimeModel {
  final int statusCode;
  final bool isSuccess;
  final List<dynamic> errorMessage; 
  final int result;

  ProfileCreateTimeModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory ProfileCreateTimeModel.fromJson(Map<String, dynamic> json) {
    return ProfileCreateTimeModel(
      statusCode: json['statusCode'] as int,
      isSuccess: json['isSuccess'] as bool,
      errorMessage: json['errorMessage'] as List<dynamic>,
      result: json['result'] as int,
    );
  }
}