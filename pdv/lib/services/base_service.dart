import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

abstract class BaseService {
  final ApiClient _apiClient = ApiClient();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<DateTime?> getTokenExpirationDate() async {
    final prefs = await SharedPreferences.getInstance();
    final expiration = prefs.getString('token_expiration');
    if (expiration != null) {
      return DateTime.parse(expiration);
    }
    return null;
  }

  Future<bool> isTokenValid() async {
    final expirationDate = await getTokenExpirationDate();
    if (expirationDate == null || expirationDate.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  Future<void> validateToken() async {
    final token = await getToken();
    if (token == null || !await isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }
  }

  ApiClient get apiClient => _apiClient;

  void dispose() {
    _apiClient.dispose();
  }
}
