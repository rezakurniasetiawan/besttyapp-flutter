import 'dart:convert';

import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/model/post_model.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:http/http.dart' as http;

import '../constan.dart';

Future<ApiResponse> getPostUsers(int userId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('https://besttyapp.skom.id/api/posts/user/$userId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        // print(jsonDecode(response.body)['post']);
        apiResponse.data = jsonDecode(response.body)['post']
            .map((p) => PostModel.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWhentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
