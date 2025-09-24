class SignupResponse {
  final bool success;
  final String message;
  final String userId;
  final String token;

  SignupResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.token,
  });

  // Factory method to create a MessageResponse from JSON
  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json['success']?? false,
      message: json['message'] ?? 'Unknown error',
      userId: json['userId'] ?? "",
      token: json['token'] ?? "",
    );
  }
}
