import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../models/album_model.dart';
import  '../../models/song_model.dart';
import '../../service/spotify_service.dart';
import '../song_detail_screen.dart';

class AlbumTracksWidget extends StatefulWidget {
  final Album album;
  final String accessToken;

  AlbumTracksWidget({required this.album, required this.accessToken});

  @override
  State<AlbumTracksWidget> createState() => _AlbumTracksWidgetState();
}

class _AlbumTracksWidgetState extends State<AlbumTracksWidget> {
  late AudioPlayer _audioPlayer;
  String? _currentlyPlayingSongId;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<List<Song>> _fetchAlbumTracks() async {
    final spotifyService = SpotifyService();
    final tracks = await spotifyService.fetchAlbumTracks(widget.album.id, widget.accessToken);
    return tracks;
  }

  void _playPauseTrack(Song song) async {
    if (_currentlyPlayingSongId == song.id) {
      _audioPlayer.stop();
      setState(() {
        _currentlyPlayingSongId = null;
      });
    } else {
      await _audioPlayer.play(UrlSource(song.previewUrl!));
      setState(() {
        _currentlyPlayingSongId = song.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: _fetchAlbumTracks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No tracks available'));
        } else {
          final tracks = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return ListTile(
                leading: IconButton(
                  icon: Icon(
                    _currentlyPlayingSongId == track.id ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () => _playPauseTrack(track),
                ),
                title: Text(track.songName, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongDetailScreen(song: track),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
