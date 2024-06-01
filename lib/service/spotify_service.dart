import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/album_model.dart';
import '../models/song_model.dart';

class SpotifyService {
  final String baseUrl = 'https://api.spotify.com/v1';

  Future<Map<String, dynamic>?> getNewReleases(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/browse/new-releases'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to get new releases: ${response.body}');
      return null;
    }
  }

  Future<List<dynamic>> getTopArtists(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?q=genre:pop&type=artist&limit=10'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['artists']['items'];
    } else {
      throw Exception('Failed to load top artists');
    }
  }

  Future<Map<String, dynamic>?> getCategories(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/browse/categories'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to get categories: ${response.body}');
      return null;
    }
  }

  Future<List<Song>> fetchAlbumTracks(String albumId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/albums/$albumId/tracks'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List tracks = data['items'];
      return tracks.map((track) => Song.fromJson(track)).toList();
    } else {
      throw Exception('Failed to load album tracks');
    }
  }

  Future<Map<String, dynamic>?>  fetchArtistTracks(String artistId, String accessToken) async {
    final url = 'https://api.spotify.com/v1/artists/$artistId/top-tracks?market=US';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final tracks = json.decode(response.body);
      return jsonDecode(response.body);

      final Map<String, dynamic> albums = tracks.map((trackJson) {
        final albumJson = trackJson['album'];
        return Album.fromJson(albumJson);
      }).toList();
      // print(albums);
      return albums;
    } else {
      throw Exception('Failed to load artist tracks. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<List<Song>> searchSongs(String query, String token) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> tracks = data['tracks']['items']['album'];

      List<Map<String, dynamic>> formattedTracks = tracks.map((track) {
        int durationMs = track['duration_ms'];

        Duration duration = Duration(milliseconds: durationMs);
        // String formattedDuration = _formatDuration(duration);
        return {
          ...track,
          'duration_ms': duration,
        };
      }).toList();

      return formattedTracks.map<Song>((track) => Song.fromJson(track)).toList();
    } else {
      print('Failed to fetch songs: ${response.body}');
      throw Exception('Failed to search songs: ${response.body}');
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  // Future<Map<String, dynamic>?> fetchArtistTracks(String artistId, String accessToken) async {
  //   final url = 'https://api.spotify.com/v1/artists/$artistId/top-tracks?market=US';
  //   final response = await http.get(Uri.parse(url), headers: {
  //     'Authorization': 'Bearer $accessToken',
  //   });
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> tracksJson = json.decode(response.body)['tracks'];
  //     print('tracksJson: $tracksJson');
  //
  //     final List<Song> songs = tracksJson.map((trackJson) {
  //       return Song.fromJson(trackJson);  // Menggunakan factory method untuk pemetaan
  //     }).toList();
  //
  //     return songs;
  //   } else {
  //     throw Exception('Failed to load artist tracks');
  //   }
  // }
}