class SignupResponse {
  final bool success;
  final String message;
  final String userId;

  SignupResponse({
    required this.success,
    required this.message,
    required this.userId,
  });

  // Factory method to create a MessageResponse from JSON
  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json['success']?? false,
      message: json['message'] ?? 'Unknown error',
      userId: json['userId'] ?? "",
    );
  }
}
