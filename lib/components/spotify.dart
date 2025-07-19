import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> authenticateWithSpotify() async {
  final clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
  final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
  final redirectUri = dotenv.env['SPOTIFY_REDIRECT_URI']!;

  final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
    'response_type': 'code',
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'scope': 'user-read-private user-read-email',
  });

  try {
    final result = await FlutterWebAuth.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: redirectUri.split(':').first, // 'myapp'
    );

    final code = Uri.parse(result).queryParameters['code'];

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
      },
    );

    final json = jsonDecode(response.body);
    final accessToken = json['access_token'];

    print("✅ Access Token: $accessToken");
    return accessToken;
  } catch (e) {
    print("❌ Spotify auth failed: $e");
    return null;
  }
}
