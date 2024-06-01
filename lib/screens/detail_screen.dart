import 'package:flutter/material.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item['images'][0]['url']),
            SizedBox(height: 8),
            Text(
              item['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // _connectToSpotifyRemote().then((_) {
                 // _playSong(item['id']);
                // });
              },
              child: Text('Play Song'),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _connectToSpotifyRemote() async {
  //   try {
  //     var result = await SpotifySdk.connectToSpotifyRemote(
  //       clientId: "xxx",
  //       clientSecret: "xxx",
  //       redirectUrl: "http://localhost:3000",
  //     );
  //     print("Connected to Spotify: $result");
  //   } catch (e) {
  //     print("Error connecting to Spotify: $e");
  //   }
  // }
  //
  // Future<void> _playSong(String uri) async {
  //   try {
  //     await SpotifySdk.play(spotifyUri: uri);
  //   } catch (e) {
  //     print("Error playing song: $e");
  //   }
  // }
}
