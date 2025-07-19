import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    print("🔗 Opening Spotify auth: $authUrl");
    final result = await FlutterWebAuth2.authenticate(
  url: authUrl.toString(),
  callbackUrlScheme: 'myapp',
);


    print("✅ Callback result: $result");

    final code = Uri.parse(result).queryParameters['code'];

    if (code == null) throw Exception("Missing code in callback");

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
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
