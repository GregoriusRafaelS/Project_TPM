import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musik_app/screens/feedback.dart';
import 'package:provider/provider.dart';
import 'models/album_model.dart';
import 'models/artists_model.dart';
import 'models/user_model.dart';
import 'screens/album_tracks_screen.dart';
import 'screens/artist_tracks_screen.dart';
import 'screens/currency_conversion_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/spotify_screen.dart';
import 'screens/time_conversion_screen.dart';
import 'service/auth_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth Hive',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomePage(),
          '/detail': (context) => DetailScreen(),
          '/spotify': (context) => SpotifyScreen(),
          '/album': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return AlbumTracksScreen(
              album: Album.fromJson(args['album']),
              accessToken: args['accessToken'] as String,
            );
          },
          '/artist': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ArtistTracksScreen(
              artists: Artists.fromJson(args['artist']),
              accessToken: args['accessToken'] as String,
            );
          },
          '/time_conversion': (context) => TimeConversionScreen(),
          '/curency_conversion': (context) => CurrencyConversionScreen(),
          '/feedback': (context) => FeedbackScreen(),
        },
      ),
    );
  }
}
