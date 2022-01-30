import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidgetModel extends ChangeNotifier {
  final String key;

  YoutubePlayerController get controller => YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

  MovieTrailerWidgetModel(this.key);
}
