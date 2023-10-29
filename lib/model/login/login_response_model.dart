class User {
  final int id;
  final String userName;
  final String name;
  final DateTime dob;
  final String address;
  final String imageUrl;
  final String phoneNumber;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final String? otp;
  final DateTime? otpExpires;
  final bool emailVerificationStatus;
  final dynamic sentFriendRequests;
  final dynamic receivedFriendRequests;

  User({
    required this.id,
    required this.userName,
    required this.name,
    required this.dob,
    required this.address,
    required this.imageUrl,
    required this.phoneNumber,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
    this.otp,
    this.otpExpires,
    required this.emailVerificationStatus,
    this.sentFriendRequests,
    this.receivedFriendRequests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  try {
    return User(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : DateTime.now(), // Provide a default value if "dob" is null or not in the expected format.
      address: json['address'],
      imageUrl: json['imageUrl'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      passwordSalt: json['passwordSalt'],
      otp: json['otp'],
      otpExpires: json['otpExpires'] != null ? DateTime.parse(json['otpExpires']) : null,
      emailVerificationStatus: json['emailVerificationStatus'],
      sentFriendRequests: json['sentFriendRequests'],
      receivedFriendRequests: json['receivedFriendRequests'],
    );
  } catch (e) {
    // Handle the exception, provide default values, or log an error.
    return User(
      id: -1, // Provide a default value for id or an appropriate value.
      userName: '',
      name: '',
      dob: DateTime.now(),
      address: '',
      imageUrl: '',
      phoneNumber: '',
      email: '',
      passwordHash: '',
      passwordSalt: '',
      otp: '',
      otpExpires: null,
      emailVerificationStatus: false,
      sentFriendRequests: null,
      receivedFriendRequests: null,
    );
  }
}

}

class LoginResponse {
  final int statusCode;
  final bool isSuccess;
  final List<String> errorMessage;
  final User? user;
  final String? token;

  LoginResponse({
    required this.statusCode,
    required this.isSuccess,
    required this.errorMessage,
    this.user,
    this.token,
  });

 factory LoginResponse.fromJson(Map<String, dynamic> json) {
  if (json['statusCode'] == 200) {
    // Successful response
    return LoginResponse(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: List<String>.from(json['errorMessage']),
      user: json['result'] != null ? User.fromJson(json['result']['user']) : null,
      token: json['result'] != null ? json['result']['token'] : null,
    );
  } else if (json['statusCode'] == 400) {
    // Error response
    final errors = json['errors'] as Map<String, dynamic>;
    final errorMessages = errors.entries
        .map((entry) => "${entry.key}: ${entry.value[0]}")
        .toList();
    
    return LoginResponse(
      statusCode: json['statusCode'],
      isSuccess: json['isSuccess'],
      errorMessage: errorMessages,
      user: null,
      token: null,
    );
  } else {
    // Handle other status codes as needed
    // You can define appropriate behavior for other status codes here.
    // For now, return a default response.
    return LoginResponse(
      statusCode: 0,
      isSuccess: false,
      errorMessage: ["Unknown error"],
      user: null,
      token: null,
    );
  }
}

}

