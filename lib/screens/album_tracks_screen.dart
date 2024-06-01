import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/album_model.dart';
import '../models/song_model.dart';
import '../service/spotify_service.dart';
import 'song_detail_screen.dart';

class AlbumTracksScreen extends StatefulWidget {
  final Album album;
  final String accessToken;

  AlbumTracksScreen({required this.album, required this.accessToken});

  @override
  State<AlbumTracksScreen> createState() => _AlbumTracksScreenState();
}

class _AlbumTracksScreenState extends State<AlbumTracksScreen> {
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

  @override
  Widget build(BuildContext context) {
    final SpotifyService spotifyService = SpotifyService();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
            widget.album.name,
            style: TextStyle(color: Colors.white),
          ),
        leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () {
          Navigator.of(context).pop();
        },
    ),
      ),
      body: FutureBuilder<List<Song>>(
        future: spotifyService.fetchAlbumTracks(widget.album.id, widget.accessToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {

            print(widget.album.id);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tracks available'));
          } else {
            print(snapshot.data!);
            print(widget.album.id);

            final songs = snapshot.data!;
            print(songs[0].songName);

            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return _buildSongCard(song, context);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSongCard(Song song, BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: widget.album.imageUrl.isNotEmpty
            ? Image.network(
          widget.album.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : Container(
          width: 50,
          height: 50,
          color: Colors.grey,
          child: Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(song.songName),
        subtitle: Text('Duration: ${_formatDuration(song.duration_ms)}'),
        trailing: IconButton(
          icon: Icon(
            _currentlyPlayingSongId == song.id ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            if (_currentlyPlayingSongId == song.id) {
              _stopSong();
            } else {
              _playSong(song);
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongDetailScreen(song: song),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _playSong(Song song) async {
    if (song.previewUrl.isNotEmpty) {
      print('Playing URL: ${song.previewUrl}');
      await _audioPlayer.play(UrlSource(song.previewUrl));
      setState(() {
        _currentlyPlayingSongId = song.id;
      });
    } else {
      print('Preview URL not available for this song');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preview URL not available for this song')),
      );
    }
  }

  Future<void> _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      _currentlyPlayingSongId = null;
    });
  }
}
