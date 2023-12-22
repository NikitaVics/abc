class BookingResponse {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  Result result;

  BookingResponse({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    required this.result,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      result: Result.fromJson(json['result']),
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
  int courtId;
  String courtName;
  final List<AvailableSlot> availableSlots;

  CourtSlot({
    required this.courtId,
    required this.courtName,
    required this.availableSlots,
  });

  factory CourtSlot.fromJson(Map<String, dynamic> json) {
    return CourtSlot(
      courtId: json['courtId'],
      courtName: json['courtName'],
      availableSlots: List<AvailableSlot>.from(
        json['availableSlots'].map(
          (slotJson) => AvailableSlot.fromJson(slotJson),
        ),
      ),
    );
  }
}

class AvailableSlot {
  final String timeSlot;
  final bool isAvailable;

  AvailableSlot({
    required this.timeSlot,
    required this.isAvailable,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      timeSlot: json['timeSlot'],
      isAvailable: json['isAvailable'],
    );
  }
}
