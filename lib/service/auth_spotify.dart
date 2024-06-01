import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthSpotify {
  final String clientId = 'xxx';
  final String clientSecret = 'xxx';
  final String _authUrl = 'https://accounts.spotify.com/api/token';

  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Access Token: ${data['access_token']}');  // Log token
      return data['access_token'];
    } else {
      print('Failed to get access token');
      return null;
    }
  }

  // Future<void> _connectToSpotify() async {
  //   try {
  //     var result = await SpotifySdk.connectToSpotifyRemote(
  //       clientId: widget.clientId,
  //       redirectUrl: widget.redirectUri,
  //     );
  //     print('Connected to Spotify: $result');
  //   } on SpotifySdkException catch (e) {
  //     print('Error connecting to Spotify: ${e.message}');
  //   }
  // }
  //
  // Future<void> _playTrack() async {
  //   try {
  //     await SpotifySdk.play(spotifyUri: 'spotify:track:${widget.trackId}');
  //     setState(() {
  //       _isPlaying = true;
  //     });
  //   } on SpotifySdkException catch (e) {
  //     print('Error playing track: ${e.message}');
  //   }
  // }
  //
  // Future<void> _pauseTrack() async {
  //   try {
  //     await SpotifySdk.pause();
  //     setState(() {
  //       _isPlaying = false;
  //     });
  //   } on SpotifySdkException catch (e) {
  //     print('Error pausing track: ${e.message}');
  //   }
  // }
}
