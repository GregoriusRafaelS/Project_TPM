import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/lyric.dart';
import '../models/song_model.dart';

class LyricsPage extends StatefulWidget {
  final Song music;
  final AudioPlayer player;

  const LyricsPage({super.key, required this.music, required this.player});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  List<Lyric>? lyrics;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.player.onPositionChanged.listen((duration) {
      DateTime dt = DateTime(1970, 1, 1).copyWith(
        hour: duration.inHours,
        minute: duration.inMinutes.remainder(60),
        second: duration.inSeconds.remainder(60),
      );
      if (lyrics != null) {
        for (int index = 0; index < lyrics!.length; index++) {
          if (index > 4 && lyrics![index].timeStamp.isAfter(dt)) {
            itemScrollController.scrollTo(
              index: index - 3,
              duration: const Duration(milliseconds: 600),
            );
            break;
          }
        }
      }
    });

    _fetchLyrics();
  }

  Future<void> _fetchLyrics() async {
    try {
      final response = await http.get(Uri.parse(
        'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${widget.music.songName} ${widget.music.artistName}&type=default',
      ));

      if (response.statusCode == 200) {
        String data = response.body;
        List<Lyric> fetchedLyrics = data
            .split('\n')
            .map((e) => Lyric(
          e.split(' ').sublist(1).join(' '),
          DateFormat("[mm:ss.SS]").parse(e.split(' ')[0]),
        ),
        ).toList();

        setState(() {
          lyrics = fetchedLyrics;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching lyrics: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching lyrics: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: lyrics != null
          ? SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(top: 20),
          child: StreamBuilder<Duration>(
            stream: widget.player.onPositionChanged,
            builder: (context, snapshot) {
              return ScrollablePositionedList.builder(
                itemCount: lyrics!.length,
                itemBuilder: (context, index) {
                  Duration duration = snapshot.data ?? const Duration(seconds: 0);
                  DateTime dt = DateTime(1970, 1, 1).copyWith(
                    hour: duration.inHours,
                    minute: duration.inMinutes.remainder(60),
                    second: duration.inSeconds.remainder(60),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      lyrics![index].words,
                      style: TextStyle(
                        color: lyrics![index].timeStamp.isAfter(dt)
                            ? Colors.white38
                            : Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              );
            },
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
