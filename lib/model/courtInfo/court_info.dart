class CourtInfo {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  final CourtInfoResult? result; // Use nullable type if "result" can be null

 CourtInfo({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    this.result,
  });

  factory CourtInfo.fromJson(Map<String, dynamic> json) {
    return CourtInfo(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: CourtInfoResult.fromJson(json['result']),
    );
  }
}

class CourtInfoResult {
  final int courtId;
  final String courtName;
  final String courtInfo;
  final List<String> courtImageURLs;
  final String startTime;
  final String endTime;
  final List<Facility> facilities;

  CourtInfoResult({
    required this.courtId,
    required this.courtName,
    required this.courtInfo,
    required this.courtImageURLs,
    required this.startTime,
    required this.endTime,
    required this.facilities,
  });

  factory CourtInfoResult.fromJson(Map<String, dynamic> json) {
    

    return CourtInfoResult(
      courtId: json['courtId'],
      courtName: json['courtName'],
      courtInfo: json['courtInfo'],
      courtImageURLs: List<String>.from(json['courtImageURLs']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      facilities: List<Facility>.from(json['facilities'].map((facilityJson)=>Facility.fromJson(facilityJson))),
    );
  }
}

class Facility {
  final String facilityName;

  Facility({required this.facilityName});

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(facilityName: json['facilityName']);
  }
}
