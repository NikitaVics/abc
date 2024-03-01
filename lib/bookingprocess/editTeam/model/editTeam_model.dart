class EditTeamModel {
  int statusCode;
  bool isSuccess;
  List<dynamic> errorMessage;
 String result;

 EditTeamModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory   EditTeamModel.fromJson(Map<String, dynamic> json) {
    return   EditTeamModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'] ?? [],
      result: json['result']??'',
    );
  }
}