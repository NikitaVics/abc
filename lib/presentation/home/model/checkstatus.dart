class CheckStatus {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  final bool result;

 CheckStatus({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory CheckStatus.fromJson(Map<String, dynamic> json) {
    return CheckStatus(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: List<String>.from(json['errorMessage'] ?? []),
      result: json['result'],
    );
  }
}
