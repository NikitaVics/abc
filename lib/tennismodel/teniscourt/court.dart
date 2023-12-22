class Court {
  int courtId;
  String courtName;
  String courtInfo;
  List<String> courtImageURLs; // Change from String to List<String>
  String startTime;
  String endTime;
  String ageGroup;

  Court({
    required this.courtId,
    required this.courtName,
    required this.courtInfo,
    required this.courtImageURLs,
    required this.startTime,
    required this.endTime,
    required this.ageGroup,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      courtId: json['courtId'],
      courtName: json['courtName'],
      courtInfo: json['courtInfo'],
      courtImageURLs: List<String>.from(json['courtImageURLs']), // Change here
      startTime: json['startTime'],
      endTime: json['endTime'],
      ageGroup: json['ageGroup'],
    );
  }
}

class CourtList {
  int statusCode;
  bool isSuccess;
  List<String> errorMessage;
  List<Court> result;

  CourtList({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory CourtList.fromJson(Map<String, dynamic> json) {
    return CourtList(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: List<Court>.from(
          json['result'].map((court) => Court.fromJson(court))),
    );
  }
}
