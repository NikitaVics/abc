class FinalBookModel {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  final int result;

  FinalBookModel({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory FinalBookModel.fromJson(Map<String, dynamic> json) {
    return FinalBookModel(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: List<String>.from(json['errorMessage'] ?? []),
      result: json['result'] ?? 0,
    );
  }
}
