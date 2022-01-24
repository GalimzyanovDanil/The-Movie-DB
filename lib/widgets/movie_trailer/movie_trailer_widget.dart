import 'package:flutter/material.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/widgets/movie_trailer/movie_trailer_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  const MovieTrailerWidget({Key? key}) : super(key: key);

  @override
  State<MovieTrailerWidget> createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  YoutubePlayerController? _controller;

  @override
  void didChangeDependencies() {
    final model = NotifierProvider.read<MovieTrailerModel>(context);
    _controller = model?.controller;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return const SizedBox.shrink();
    final player = YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
    );
    return YoutubePlayerBuilder(
      player: player,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Трейлер'),
          ),
          body: ColoredBox(
            color: const Color.fromRGBO(24, 23, 27, 1.0),
            child: Center(child: player),
          ),
        );
      },
    );
  }
}
