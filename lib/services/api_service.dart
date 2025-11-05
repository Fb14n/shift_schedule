// language: dart
// Datei: `lib/services/api_service.dart` (angepasst)
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String? baseUrl = dotenv.env['BASE_URL'];
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  static const String _keyJwt = 'jwt_token';
  static const String _keyRefresh = 'refresh_token';
  static const String _keyExpiry = 'token_expiry';

  Future<String> login(String username, String password) async {
    log('API-Base-Url: ${dotenv.env['BASE_URL']}', name: 'ApiService');
    final response = await http.post(
      Uri.parse('${baseUrl ?? ''}/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final access = data['access_token'] as String?;
      final refresh = data['refresh_token'] as String?;
      if (access != null) {
        await _saveTokenData(access, refreshToken: refresh, fallbackExpiryHours: 2);
        log('Login successful, token saved', name: 'ApiService');
        return access;
      } else {
        throw Exception('Login failed: Token not found in response');
      }
    } else {
      final errorResponse = response.body.isNotEmpty ? json.decode(response.body) : {};
      throw Exception('Login failed: ${errorResponse['error'] ?? 'Unknown error'}');
    }
  }

  Future<void> logout() async {
    try {
      await storage.delete(key: _keyJwt);
      await storage.delete(key: _keyRefresh);
      await storage.delete(key: _keyExpiry);
      log('Logout successful: credentials cleared', name: 'ApiService');
    } catch (e) {
      log('Logout failed: $e', name: 'ApiService');
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> saveToken(String token) async {
    await _saveTokenData(token, fallbackExpiryHours: 2);
    log('Token saved', name: 'ApiService');
  }

  Future<String?> readRawToken() async => await storage.read(key: _keyJwt);
  Future<void> deleteToken() async => await storage.delete(key: _keyJwt);

  Future<String?> getToken() async {
    final token = await storage.read(key: _keyJwt);
    if (token == null) return null;
    final expiryIso = await storage.read(key: _keyExpiry);
    if (expiryIso != null) {
      final expiry = DateTime.tryParse(expiryIso);
      if (expiry != null && DateTime.now().isBefore(expiry)) return token;
    }
    final refreshed = await refreshToken();
    return refreshed;
  }

  Future<String?> refreshToken() async {
    final refresh = await storage.read(key: _keyRefresh);
    if (refresh == null) return null;
    try {
      final response = await http.post(
        Uri.parse('${baseUrl ?? ''}/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refresh}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['access_token'] as String?;
        final newRefresh = data['refresh_token'] as String?;
        if (newAccess != null) {
          await _saveTokenData(newAccess, refreshToken: newRefresh, fallbackExpiryHours: 2);
          log('Token refreshed successfully', name: 'ApiService');
          return newAccess;
        }
      } else {
        log('Refresh failed: ${response.statusCode} ${response.body}', name: 'ApiService');
      }
    } catch (e) {
      log('Refresh exception: $e', name: 'ApiService');
    }
    await logout();
    return null;
  }

  Future<void> _saveTokenData(String accessToken, { String? refreshToken, int? fallbackExpiryHours }) async {
    await storage.write(key: _keyJwt, value: accessToken);
    if (refreshToken != null) await storage.write(key: _keyRefresh, value: refreshToken);
    final expiry = _parseJwtExpiry(accessToken) ?? DateTime.now().add(Duration(hours: fallbackExpiryHours ?? 2));
    await storage.write(key: _keyExpiry, value: expiry.toIso8601String());
  }

  DateTime? _parseJwtExpiry(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      if (map.containsKey('exp')) {
        final exp = map['exp'];
        int? seconds;
        if (exp is int) {
          seconds = exp;
        } else if (exp is double) seconds = exp.toInt();
        else if (exp is String) seconds = int.tryParse(exp);
        else if (exp is num) seconds = exp.toInt();
        if (seconds != null) return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).toLocal();
      }
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchShifts([String? token]) async {
    final usedToken = token ?? await getToken();
    if (usedToken == null) throw Exception('Kein Token gefunden');
    if (baseUrl == null || baseUrl!.isEmpty) throw Exception('BASE_URL nicht konfiguriert');
    try {
      final response = await http.get(Uri.parse('$baseUrl/shifts'), headers: {'Authorization': 'Bearer $usedToken'});
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        final bodySnippet = response.body.length > 500 ? '${response.body.substring(0, 500)}...' : response.body;
        throw Exception('Failed to load shifts: ${response.statusCode} ${bodySnippet}');
      }
    } catch (e) {
      log('fetchShifts error: $e', name: 'ApiService');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchShiftsStored() async => fetchShifts();

  Future<List<Map<String, dynamic>>> fetchAllShifts() async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.get(Uri.parse('$baseUrl/shifts/all'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    else throw Exception('Fehler beim Laden aller Schichten');
  }

  Future<List<Map<String, dynamic>>> getShiftTypes() async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.get(Uri.parse('$baseUrl/shift-types'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    else {
      log('Fehler beim Abrufen der Schichttypen: ${response.statusCode}', name: 'ApiService');
      throw Exception('Fehler beim Laden der Schichttypen');
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails() async {
    final token = await getToken();
    if (token == null) throw Exception('No token stored');
    final response = await http.get(Uri.parse('$baseUrl/user/details'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      log('User details fetched', name: 'ApiService');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user details: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchShiftsForUser(int userId) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    if (baseUrl == null || baseUrl!.isEmpty) throw Exception('BASE_URL nicht konfiguriert');

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/shifts/user/$userId'),
          headers: {'Authorization': 'Bearer $token'}
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        final bodySnippet = response.body.length > 500 ? '${response.body.substring(0, 500)}...' : response.body;
        throw Exception('Failed to load shifts for user $userId: ${response.statusCode} $bodySnippet');
      }
    } catch (e) {
      log('fetchShiftsForUser error for user $userId: $e', name: 'ApiService');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.get(Uri.parse('$baseUrl/users'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Fehler beim Laden der Benutzer');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCompanies() async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.get(Uri.parse('$baseUrl/companies'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Fehler beim Laden der Firmen');
    }
  }

  Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String employeeId,
    required String password,
    int? companyId,
    int? vacationDays,
    bool? isAdmin,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final body = {
      'first_name': firstName,
      'last_name': lastName,
      'employee_id': int.tryParse(employeeId) ?? employeeId,
      'password': password,
      if (companyId != null) 'company_id': companyId,
      if (vacationDays != null) 'vacation_days': vacationDays,
      if (isAdmin != null) 'is_admin': isAdmin,
    };
    final response = await http.post(Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fehler beim Erstellen des Benutzers: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> updates) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.put(Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(updates),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fehler beim Aktualisieren des Benutzers: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createCompany({ required String name, String? address }) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.post(Uri.parse('$baseUrl/companies'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'name': name, if (address != null) 'address': address}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fehler beim Erstellen der Firma: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateCompany(int id, Map<String, dynamic> updates) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.put(Uri.parse('$baseUrl/companies/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(updates),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fehler beim Aktualisieren der Firma: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createShift({
    required int userId,
    required String shiftDate, // ISO yyyy-mm-dd
    required int shiftTypeId,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.post(Uri.parse('$baseUrl/shifts'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'user_id': userId,
        'shift_date': shiftDate,
        'shift_type_id': shiftTypeId,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fehler beim Erstellen der Schicht: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateShift(int id, Map<String, dynamic> updates) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    final response = await http.put(Uri.parse('$baseUrl/shifts/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(updates),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fehler beim Aktualisieren der Schicht: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateShiftTypeColor(int id, String newColor) async {
    final token = await getToken();
    if (token == null) throw Exception('Kein Token gefunden');
    if (!newColor.startsWith('#') || newColor.length != 7) throw Exception('Ungültiges Farbformat. Benutze #RRGGBB.');
    final response = await http.put(Uri.parse('$baseUrl/shift-types/$id/color'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'color': newColor}),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    else {
      log('Fehler beim Aktualisieren der Schichtfarbe: ${response.statusCode}', name: 'ApiService');
      throw Exception('Fehler beim Aktualisieren der Schichtfarbe');
    }
  }

  Future<void> resetPassword({ required String username, required String employeeId, required String newPassword }) async {
    final response = await http.post(Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'employeeId': employeeId, 'newPassword': newPassword}),
    );
    if (response.statusCode == 200) return;
    else {
      final errorData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw Exception(errorData['error'] ?? 'Unbekannter Fehler beim Zurücksetzen des Passworts.');
    }
  }
}