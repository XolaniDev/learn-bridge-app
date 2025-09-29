import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../data/dashboardResponse.dart';
import '../data/funding_response.dart';
import '../data/job_market_response.dart';
import '../data/message_response.dart';
import '../data/profile/user_profile.dart' as profile_data;
import '../data/user_response.dart';
import '../data/signup_response.dart';
import '../data/user.dart';
import '../utils/profile_setup_data.dart';

class Service {

    final String authBaseUrl = 'http://154.0.166.216:8091/api/auth';
    final String lbBaseUrl = 'http://154.0.166.216:8091/api/lb';

    final Dio dio;

    static final Service _instance = Service._internal();

    factory Service() => _instance;

    Service._internal() : dio = _initializeDio();

    static Dio _initializeDio() {
        final CookieJar cookieJar = CookieJar();
        final dio = Dio();
        dio.httpClientAdapter = IOHttpClientAdapter();
        dio.interceptors.add(CookieManager(cookieJar));
        return dio;
    }

    Future<MessageResponse> signup({
        required String name,
        required String surname,
        required String email,
        required String phoneNumber,
        required String password,
    }) async {
        final url = Uri.parse('$authBaseUrl/signup');

        final Map<String, dynamic> requestBody = {
            "name": name,
            "surname": surname,
            "email": email,
            "phoneNumber": phoneNumber,
            "password": password,
        };

        try {
            final response = await http.post(
                url,
                headers: {
                    'Content-Type': 'application/json',
                    'accept': '*/*',
                },
                body: jsonEncode(requestBody),
            );

            print("🔍 Raw response status: ${response.statusCode}");
            print("🔍 Raw response body: ${response.body}");

            if (response.statusCode == 200 || response.statusCode == 400) {
                final responseData = jsonDecode(response.body);
                await SessionManager().set("userId", SignupResponse.fromJson(responseData).userId);
                return MessageResponse.fromJson(responseData);
            } else {
                return MessageResponse(
                    success: false, message: "An unknown error occurred.");
            }
        } catch (e) {
            return MessageResponse(
                success: false, message: "Error during signup: $e");
        }
    }

    Future<profile_data.UserProfile> login(String email, String password) async {
        try {
            final response = await dio.post(
                '$authBaseUrl/signin',
                data: {
                    "username": email,
                    "password": password,
                },
                options: Options(
                    headers: {
                        'Content-Type': 'application/json',
                        'accept': '*/*',
                    },
                ),
            );

            final profile = profile_data.UserProfile.fromJson(response.data);
            await SessionManager().set("userId", UserResponse.fromJson(response.data).id);
            await SessionManager().set("userData", jsonEncode(response.data));

            return profile;
        } catch (e) {
            print('Login failed: $e');
            rethrow;
        }
    }


    Future<UserResponse?> getUserById() async {
        try {

            final userId = await SessionManager().get("userId");
            final response = await dio.get(
                '$lbBaseUrl/find-user-by-id/$userId',
                options: Options(
                    headers: {
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200) {
                return UserResponse.fromJson(response.data);
            } else {
                print("Failed to fetch user: ${response.statusCode} - ${response.data}");
                return null;
            }
        } catch (e) {
            print('Failed to fetch or store farm data: $e');
            rethrow;
        }
    }

    // fetch data to dahsboard
    Future<DashboardResponse?> getDashboardData() async {
        try {
            final userId = await SessionManager().get("userId");
            final response = await dio.get(
                '$lbBaseUrl/dashboard/$userId',
                options: Options(
                    headers: {
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200) {
                return DashboardResponse.fromJson(response.data);
            } else {
                print("Failed to fetch dashboard: ${response.statusCode} - ${response.data}");
                return null;
            }
        } catch (e) {
            print('Failed to fetch dashboard data: $e');
            rethrow;
        }
    }

    Future<JobMarketResponse?> getJobMarketData() async {
        try {
            final userId = await SessionManager().get("userId");
            final response = await dio.get(
                '$lbBaseUrl/job-market/$userId',
                options: Options(
                    headers: {
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200) {
                return JobMarketResponse.fromJson(response.data);
            } else {
                print(
                    "Failed to fetch job market: ${response.statusCode} - ${response.data}");
                return null;
            }
        } catch (e) {
            print('Failed to fetch job market data: $e');
            rethrow;
        }
    }

    Future<FundingResponse?> getFundingData() async {
        try {
            final userId = await SessionManager().get("userId");
            final response = await dio.get(
                '$lbBaseUrl/funding/$userId',
                options: Options(
                    headers: {
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200) {
                return FundingResponse.fromJson(response.data);
            } else {
                print(
                    "Failed to fetch funding data: ${response.statusCode} - ${response.data}");
                return null;
            }
        } catch (e) {
            print('Failed to fetch funding data: $e');
            rethrow;
        }
    }

    Future<MessageResponse> updateUser(
    {
        required String name,
        required String surname,
        required String email,
        required String phoneNumber}) async {

        final userId = await SessionManager().get("userId");
        final Map<String, dynamic> requestBody = {
            "userId": userId,
            "name": name,
            "surname": surname,
            "email": email,
            "phoneNumber": phoneNumber,
        };

        try {
            final response = await dio.post(
                '$lbBaseUrl/update-user',
                data: jsonEncode(requestBody),
                options: Options(
                    headers: {
                        'Content-Type': 'application/json',
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200) {
                final user = User.fromJson(response.data);
                await SessionManager().set("userData", jsonEncode(response.data));

                MessageResponse messageResponse = MessageResponse(
                    success: true, message: "User details updated successfully");
                return messageResponse;
            } else if (response.statusCode == 400) {
                final responseData = jsonDecode(response.data);
                return MessageResponse.fromJson(responseData);
            } else {
                return MessageResponse(
                    success: false, message: "An unknown error occurred.");
            }
        } on DioException catch (e) {
            if (e.response?.statusCode == 400) {
                return MessageResponse(
                    success: false,
                    message: e.response?.data['message'] ??
                        "Error while updating personal details, please try again.");
            } else {
                return MessageResponse(
                    success: false,
                    message:
                    "Error while updating personal details, please try again.");
            }
        } catch (e) {
            return MessageResponse(
                success: false,
                message: "Error while updating personal details, please try again.");
        }
    }


    Future<MessageResponse> updateLoginDetails({
        required String userId,
        required String currentPassword,
        required String newPassword,
    }) async {
        final Map<String, dynamic> requestBody = {
            "userId": userId,
            "currentPassword": currentPassword,
            "newPassword": newPassword,
        };

        try {
            final response = await dio.post(
                '$lbBaseUrl/update-login-details',
                data: jsonEncode(requestBody),
                options: Options(
                    headers: {
                        'Content-Type': 'application/json',
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200) {
                MessageResponse messageResponse =
                    MessageResponse(success: true, message: "Login details updated");
                return messageResponse;
            } else if (response.statusCode == 400) {
                final responseData = jsonDecode(response.data);
                return MessageResponse.fromJson(responseData);
            } else {
                return MessageResponse(
                    success: false, message: "An unknown error occurred.");
            }
        } on DioException catch (e) {
            if (e.response?.statusCode == 400) {
                return MessageResponse(
                    success: false,
                    message: e.response?.data['message'] ??
                        "Error while updating login details, please try again.");
            } else {
                return MessageResponse(
                    success: false,
                    message: "Error while updating login details, please try again.");
            }
        } catch (e) {
            return MessageResponse(
                success: false,
                message: "Error while updating login details, please try again.");
        }
    }


    Future<MessageResponse> profileSetUp({
        required String province,
        required String? grade,
        required List<String> interests,
        required List<String> subjects,
        required String financialBackground,
    }) async {
        final url = Uri.parse('$authBaseUrl/profile-setup');

        final userId = await SessionManager().get("userId");
        final Map<String, dynamic> requestBody = {
            "userId": userId,
            "province": province,
            "grade": grade,
            "interests": interests,
            "subjects": subjects,
            "financialBackground": financialBackground,
        };

        try {
            final response = await http.post(
                url,
                headers: {
                    'Content-Type': 'application/json',
                    'accept': '*/*',
                },
                body: jsonEncode(requestBody),
            );


            if (response.statusCode == 200 || response.statusCode == 400) {
                final responseData = jsonDecode(response.body);
                return MessageResponse.fromJson(responseData);
            } else {
                return MessageResponse(
                    success: false, message: "An unknown error occurred.");
            }
        } catch (e) {
            return MessageResponse(
                success: false, message: "Error during signup: $e");
        }
    }

    Future<MessageResponse> updateProfile({
        required String province,
        required String? grade,
        required List<String> interests,
        required List<String> subjects,
        required String financialBackground,
    }) async {
        final userId = await SessionManager().get("userId");

        final Map<String, dynamic> requestBody = {
            "userId": userId,
            "province": province,
            "grade": grade,
            "interests": interests,
            "subjects": subjects,
            "financialBackground": financialBackground,
        };

        try {
            final response = await dio.post(
                '$lbBaseUrl/update-profile-setup',
                data: jsonEncode(requestBody),
                options: Options(
                    headers: {
                        'Content-Type': 'application/json',
                        'accept': '*/*',
                    },
                ),
            );

            if (response.statusCode == 200 || response.statusCode == 400) {
                return MessageResponse(
                    success: true, message: "Profile updated successfully.");
            } else {
                return MessageResponse(
                    success: false, message: "An unknown error occurred.");
            }
        } catch (e) {
            return MessageResponse(
                success: false, message: "Error during signup: $e");
        }
    }

}
