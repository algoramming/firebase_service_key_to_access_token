import 'package:googleapis_auth/auth_io.dart';

class GoogleServerService {
  Future<String> getAccessToken(Map<String, dynamic> json) async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(json),
      scopes,
    );
    final accessToken = client.credentials.accessToken.data;
    return accessToken;
  }
}
