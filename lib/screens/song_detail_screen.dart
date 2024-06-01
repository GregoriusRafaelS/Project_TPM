import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:palette_generator/palette_generator.dart';
import '../models/song_model.dart';
import 'lyrics.dart';
import 'widgets/art_work_image.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  SongDetailScreen({required this.song});

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchSongDetails();
  }

  Future<void> _fetchSongDetails() async {
    try {
      final credentials = SpotifyApiCredentials(
        'xxx',
        'xxx',
      );
      final spotify = SpotifyApi(credentials);
      final track = await spotify.tracks.get(widget.song.id);

      setState(() {
        widget.song.songName = track.name ?? widget.song.songName;
        widget.song.artistName = track.artists?.first.name ?? "";
      });

      final image = track.album?.images?.first.url;
      if (image != null) {
        widget.song.songImage = image;
        final tempSongColor = await getImagePalette(NetworkImage(image));
        if (tempSongColor != null) {
          widget.song.songColor = tempSongColor;
        }
      }

      final yt = YoutubeExplode();
      final video = (await yt.search.search("${widget.song.songName} ${widget.song.artistName}")).first;
      final videoId = video.id.value;
      widget.song.duration_ms = video.duration!;

      setState(() {});

      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.last.url;
      await _audioPlayer.play(UrlSource(audioUrl.toString()));
    } catch (e) {
      print('Error fetching song details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching song details')),
      );
    }
  }

  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong() async {
    if (widget.song.previewUrl.isNotEmpty) {
      print('Playing URL: ${widget.song.previewUrl}');
      await _audioPlayer.play(UrlSource(widget.song.previewUrl));
    } else {
      print('Preview URL not available for this song');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preview URL not available for this song')),
      );
    }
  }

  void _stopSong() {
    _audioPlayer.stop();
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.close, color: Colors.transparent),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Singing Now',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: widget.song.artistImage != null
                                ? NetworkImage(widget.song.artistImage!)
                                : null,
                            radius: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.song.artistName ?? '-',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                  const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ],
              ),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: ArtWorkImage(image: widget.song.songImage),
                  )),
              Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.song.songName ?? '',
                                style: textTheme.titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                              Text(
                                widget.song.artistName ?? '-',
                                style: textTheme.titleMedium
                                    ?.copyWith(color: Colors.white60),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder(
                          stream: _audioPlayer.onPositionChanged,
                          builder: (context, data) {
                            return ProgressBar(
                              progress: data.data ?? const Duration(seconds: 0),
                              total: widget.song.duration_ms ?? const Duration(minutes: 4),
                              bufferedBarColor: Colors.white38,
                              baseBarColor: Colors.white10,
                              thumbColor: Colors.white,
                              timeLabelTextStyle:
                              const TextStyle(color: Colors.white),
                              progressBarColor: Colors.white,
                              onSeek: (duration) {
                                _audioPlayer.seek(duration);
                              },
                            );
                          }),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LyricsPage(music: widget.song, player: _audioPlayer,)));
                              },
                              icon: const Icon(Icons.lyrics_outlined,
                                  color: Colors.white)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.skip_previous,
                                  color: Colors.white, size: 36)),
                          IconButton(
                              onPressed: () async {
                                if (_audioPlayer.state == PlayerState.playing) {
                                  await _audioPlayer.pause();
                                } else {
                                  await _audioPlayer.resume();
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                _audioPlayer.state == PlayerState.playing
                                    ? Icons.pause
                                    : Icons.play_circle,
                                color: Colors.white,
                                size: 60,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.skip_next,
                                  color: Colors.white, size: 36)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.loop,
                                  color: Colors.yellow)),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
