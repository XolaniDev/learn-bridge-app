import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../data/message_response.dart';
import '../data/user.dart';

class Service {

    final String authBaseUrl = 'http://154.0.166.216:8090/api/auth';
    final String farmBaseUrl = 'http://154.0.166.216:8090/api/lb';

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
                // Parse the response body and return a MessageResponse object
                final responseData = jsonDecode(response.body);
                return MessageResponse.fromJson(responseData);
            } else {
                // Handle other status codes
                return MessageResponse(
                    success: false, message: "An unknown error occurred.");
            }
        } catch (e) {
            // Handle network or other errors
            return MessageResponse(
                success: false, message: "Error during signup: $e");
        }
    }

    Future<User> login(String email, String password) async {
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

            final user = User.fromJson(response.data);
            await SessionManager().set("userData", jsonEncode(response.data));

            return user;
        } catch (e) {
            print('Login failed: $e');
            rethrow;
        }
    }



    Future<MessageResponse> updateUser(
    {required String id,
        required String farmId,
        required String name,
        required String surname,
        required String email,
        required String phoneNumber}) async {
        final Map<String, dynamic> requestBody = {
            "id": id,
            "farmId": farmId,
            "name": name,
            "surname": surname,
            "email": email,
            "phoneNumber": phoneNumber,
        };

        try {
            final response = await dio.post(
                '$farmBaseUrl/update-user',
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
                '$farmBaseUrl/update-login-details',
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


}
