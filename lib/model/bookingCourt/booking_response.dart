class BookingResponse {
  Result result;
  int id;
  dynamic exception;
  int status;
  bool isCanceled;
  bool isCompleted;
  bool isCompletedSuccessfully;
  int creationOptions;
  dynamic asyncState;
  bool isFaulted;

  BookingResponse({
    required this.result,
    required this.id,
    required this.exception,
    required this.status,
    required this.isCanceled,
    required this.isCompleted,
    required this.isCompletedSuccessfully,
    required this.creationOptions,
    required this.asyncState,
    required this.isFaulted,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      result: Result.fromJson(json['result']),
      id: json['id'],
      exception: json['exception'],
      status: json['status'],
      isCanceled: json['isCanceled'],
      isCompleted: json['isCompleted'],
      isCompletedSuccessfully: json['isCompletedSuccessfully'],
      creationOptions: json['creationOptions'],
      asyncState: json['asyncState'],
      isFaulted: json['isFaulted'],
    );
  }
}

class Result {
  String bookingDate;
  List<CourtSlot> courtsWithSlots;

  Result({
    required this.bookingDate,
    required this.courtsWithSlots,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      bookingDate: json['bookingDate'],
      courtsWithSlots: List<CourtSlot>.from(
        json['courtsWithSlots'].map((court) => CourtSlot.fromJson(court)),
      ),
    );
  }
}

class CourtSlot {
  String courtName;
  List<String> availableSlots;

  CourtSlot({
    required this.courtName,
    required this.availableSlots,
  });

  factory CourtSlot.fromJson(Map<String, dynamic> json) {
    return CourtSlot(
      courtName: json['courtName'],
      availableSlots: List<String>.from(json['availableSlots']),
    );
  }
}