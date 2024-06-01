import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../service/acces_token.dart';
import '../service/auth_spotify.dart';
import '../service/auth_user.dart';
import '../service/spotify_service.dart';
import 'widgets/list_song.dart';

class SpotifyScreen extends StatefulWidget {
  @override
  _SpotifyScreenState createState() => _SpotifyScreenState();
}

class _SpotifyScreenState extends State<SpotifyScreen> {
  final SpotifyService _spotifyService = SpotifyService();
  final AuthSpotify _authService = AuthSpotify();
  String accessToken = '';
  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>?>? _albums;
  Future<List<dynamic>?>? _artists;
  Future<Map<String, dynamic>?>? _genres;
  Future<List<Song>>? _songs;

  @override
  void initState() {
    super.initState();
    _fetchSpotifyData();
  }

  Future<void> _fetchSpotifyData() async {
    final token = await _authService.getAccessToken();
    await SharedPreferencesToken.saveAccesToken(token);
    accessToken = await SharedPreferencesToken.getAccesToken();

    if (accessToken != null) {
      setState(() {
        _albums = _spotifyService.getNewReleases(accessToken);
        _artists = _spotifyService.getTopArtists(accessToken);
        _genres = _spotifyService.getCategories(accessToken);
        _songs = _spotifyService.searchSongs("Louder", accessToken);
      });
    } else {
      print('Failed to obtain access token.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Welcome, ${Provider.of<AuthUser>(context).currentUser?.username}!',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _songs != null ? FutureBuilder<List<Song>>(
              future: _songs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error fetching songs: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No data or empty data');
                  return Center(child: Text('No songs available'));
                } else {
                  final songs = snapshot.data!;
                  return AlbumTracksWidget(album: songs[0].album, accessToken: accessToken);
                }
              },
            ) : Container(),
            _buildSearchBar(),
            _buildSection('New Released', _albums),
            _buildArtistSection('Artists', _artists),
            _buildSection('Genres', _genres),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search for songs...',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(Icons.search, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) => _searchSongs(),
      ),
    );
  }

  Widget _buildSection(String title, Future<Map<String, dynamic>?>? dataFuture) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          FutureBuilder<Map<String, dynamic>?>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
              } else {
                final items = (title == 'New Released') ? snapshot.data!['albums']['items'] :
                snapshot.data!['categories']['items'];
                return Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildItemCard(item, title);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArtistSection(String title, Future<List<dynamic>?>? dataFuture) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          FutureBuilder<List<dynamic>?>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
              } else {
                final items = snapshot.data!;
                return Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildItemCard(item, title);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(dynamic item, String type) {
    final imageUrl = (type == 'New Released' || type == 'Artists')
        ? item['images'][0]['url']
        : item['icons'][0]['url'];
    final name = item['name'];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          type == 'New Released' ? '/album' : '/artist',
          arguments: {
            'album': type == 'New Released' ? item : null,
            'artist': type == 'Artists' ? item : null,
            'accessToken': accessToken,
          },
        );
      },
      child: Card(
        color: Colors.grey[850],
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Container(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl, height: 120, width: 150, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchSongs() async {
    final search = _searchController.text;

    final songResults = _spotifyService.searchSongs(search, accessToken);

    setState(() {
      _songs = songResults;
    });
  }
}
