import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spotify;

import 'album_model.dart';

class Song {
  String id;
  String songName;
  String artistName;
  String previewUrl;
  Duration duration_ms;
  Album album;
  String artistImage = "";
  String songImage = "";
  Color songColor = Colors.white;

  Song({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.previewUrl,
    required this.duration_ms,
    required this.album,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Album data is missing');
    }
    Album album = Album.fromJson(json);
    return Song(
      id: json['id'] as String,
      songName: json['name'] as String,
      artistName: json['artists'][0]['name'] as String,
      previewUrl: json['preview_url'] as String? ?? '',
      duration_ms: Duration(milliseconds: json['duration_ms'] as int),
      album: album,
    );
  }

}
