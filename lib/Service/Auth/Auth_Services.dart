import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pagedrop/utils/Logger/logger.dart';
import '../../utils/AppConstant/app_contants.dart';
import '../../utils/TokenService/token_service.dart';

class AuthService {
  static Future<bool> refreshToken() async {
    try {
      final refreshToken = await TokenService().getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        Logger.log("No refresh token available", type: "error");
        return false;
      }

      // Updated to use the correct API endpoint based on the project structure
      final url = "${AppConstants.BASE_URL}/api/v1/Auth/refresh-token";

      Logger.log("🔄 Attempting to refresh token...", type: "info");
      Logger.log("Using refresh endpoint: $url", type: "info");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      Logger.log("Refresh Response Status: ${response.statusCode}", type: "info");
      Logger.log("Refresh Response Body: ${response.body}", type: "info");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final newAccessToken = data["accessToken"] ?? data["access_token"] ?? data["data"]?["accessToken"];
        final newRefreshToken = data["refreshToken"] ?? data["refresh_token"] ?? data["data"]?["refreshToken"];

        if (newAccessToken != null && newRefreshToken != null) {
          await TokenService().saveToken(newAccessToken);
          await TokenService().saveRefreshToken(newRefreshToken);
          await TokenService().reloadTokens();
          Logger.log("Token refreshed and reloaded successfully!", type: "info");
          return true;
        } else {
          Logger.log("New tokens not found in response", type: "warning");
          Logger.log("Response data: $data", type: "warning");
          return false;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Logger.log("Refresh token invalid or expired, clearing all tokens", type: "warning");
        await TokenService().clearAll();
        return false;
      } else {
        Logger.log("❌ Token refresh failed with status: ${response.statusCode}", type: "error");
        return false;
      }
    } catch (e, stackTrace) {
      Logger.log("Error during token refresh: $e", type: "error");
      Logger.log("Stack trace: $stackTrace", type: "error");
      return false;
    }
  }

  /// Validates the current access token by making a test API call
  /// Returns true if token is valid, false if invalid or expired
  static Future<bool> validateToken() async {
    try {
      final token = await TokenService().getToken();

      if (token == null || token.isEmpty) {
        Logger.log('No token available for validation', type: 'warning');
        return false;
      }

      // Test the token by making a simple API call that requires authentication
      final url = '${AppConstants.BASE_URL}/api/v1/Auth/validate-token';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Logger.log('Token validation response status: ${response.statusCode}', type: 'info');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isValid = data['isValid'] ?? data['success'] ?? false;
        Logger.log('Token validation result: $isValid', type: 'info');
        return isValid;
      } else if (response.statusCode == 401) {
        Logger.log('Token validation failed - 401 Unauthorized', type: 'warning');
        return false;
      } else {
        Logger.log('Token validation failed with status: ${response.statusCode}', type: 'error');
        return false;
      }
    } catch (e) {
      Logger.log('Error during token validation: $e', type: 'error');
      return false;
    }
  }

  /// Validates the token and attempts to refresh if invalid
  /// Returns true if token is valid or successfully refreshed, false otherwise
  static Future<bool> validateAndRefreshToken() async {
    Logger.log('Starting token validation and refresh process', type: 'info');

    // First, try to validate the current token
    bool isValid = await validateToken();

    if (isValid) {
      Logger.log('Token is valid, no refresh needed', type: 'success');
      return true;
    }

    Logger.log('Token is invalid or expired, attempting refresh', type: 'info');

    // Token is invalid, try to refresh it
    bool refreshSuccess = await refreshToken();

    if (refreshSuccess) {
      Logger.log('Token successfully refreshed', type: 'success');
      return true;
    } else {
      Logger.log('Failed to refresh token', type: 'error');
      return false;
    }
  }

  static Future<void> logout() async {
    await TokenService().clearAll();
    Logger.log("✅ User logged out successfully", type: "info");
  }
}