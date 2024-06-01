import 'package:flutter/material.dart';
import 'package:musik_app/models/artists_model.dart';
import 'package:musik_app/service/spotify_service.dart';

class ArtistTracksScreen extends StatelessWidget {
  final Artists artists;
  final String accessToken;

  ArtistTracksScreen({required this.artists, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    final SpotifyService spotifyService = SpotifyService();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
          title: Text(
              'Artist Tracks',
            style:  TextStyle(color: Colors.white),
          ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: spotifyService.fetchArtistTracks(artists.id, accessToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tracks available'));
          } else {
            final albums = snapshot.data!['tracks'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Albums",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index]['album'];
                        return _buildItemCard(album, context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildItemCard(dynamic album, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/album',
          arguments: {
            'album': album,
            'accessToken': accessToken,
          },
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Container(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.network(
                  album['images'][0]['url'],
                  height: 120,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  album['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
