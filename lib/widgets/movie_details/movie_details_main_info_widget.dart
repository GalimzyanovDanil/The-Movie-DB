import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/path_factories.dart';
import 'package:the_movie_db/widgets/elements/radial_percent_widget.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummeryWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(height: 20),
        _PeopleWidgets(),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview =
        context.watch<MovieDetailsWidgetModel>().movieDetails?.overview;

    return Text(
      overview ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsWidgetModel>();
    final movieDetails = model.movieDetails;
    final backdropPath = movieDetails?.backdropPath;
    final posterPath = movieDetails?.posterPath;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          (backdropPath != null)
              ? Image.network(PathFactories.createPosterPath(backdropPath))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: (posterPath != null)
                ? Image.network(PathFactories.createPosterPath(posterPath))
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => model.markAsFavorite(context),
              icon: (model.isFavorite == true)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                      color: Colors.red,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails = context.watch<MovieDetailsWidgetModel>().movieDetails;
    final title = movieDetails?.title;
    String? year = movieDetails?.releaseDate?.year.toStringAsFixed(0);
    year = (year != null) ? ' ($year)' : '';

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: year,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails = context.watch<MovieDetailsWidgetModel>().movieDetails;
    var voteAverage = movieDetails?.voteAverage ?? 0;
    var textVoteAverage = (voteAverage * 10).toStringAsFixed(0);
    var percentVoteAverage = (voteAverage / 10);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: RadialPercentWidget(
                  percent: percentVoteAverage,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3,
                  child: Text(textVoteAverage),
                ),
              ),
              const SizedBox(width: 10),
              const Text('User Score'),
            ],
          ),
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        const _TrailerButtonWidget(),
      ],
    );
  }
}

class _TrailerButtonWidget extends StatelessWidget {
  const _TrailerButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsWidgetModel>();
    final movieDetails = model.movieDetails;

    final videos = movieDetails?.videos.results
        .where((result) => result.site == 'YouTube' && result.type == 'Trailer')
        .toList();

    if (videos == null || videos.isEmpty) return const SizedBox.shrink();

    return TextButton(
      onPressed: () => model.onTapTrailer(
        key: videos.first.key,
        context: context,
      ),
      child: Row(
        children: const [
          Icon(Icons.play_arrow),
          Text('Play Trailer'),
        ],
      ),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsWidgetModel>();
    var infoText = <String>[];

    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      infoText.add(model.releaseDateToString(releaseDate));
    }

    final modelProductionCountries = model.movieDetails?.productionCountries;
    var productionCountries = <String>[];

    if (modelProductionCountries != null) {
      for (var item in modelProductionCountries) {
        productionCountries.add(item.iso31661);
      }
      infoText.add('(${productionCountries.join(', ')})');
    }
    final modelRuntime = model.movieDetails?.runtime;
    final String runtime;
    if (modelRuntime != null) {
      final dtRuntime = DateTime.fromMillisecondsSinceEpoch(
          modelRuntime * 60000,
          isUtc: true);

      runtime = '${dtRuntime.hour}ч ${dtRuntime.minute}мин';
      infoText.add(runtime);
    }

    final modelgenres = model.movieDetails?.genres;
    var genres = <String>[];

    if (modelgenres != null) {
      for (var item in modelgenres) {
        genres.add(
            item.name.replaceFirst(item.name[0], item.name[0].toUpperCase()));
      }
      infoText.add('\n${genres.join(', ')}');
    }

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Center(
          child: Text(
            infoText.join(' '),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _PeopleWidgets extends StatelessWidget {
  const _PeopleWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crew =
        context.watch<MovieDetailsWidgetModel>().movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();

    const nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    final jobTilteStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    return GridView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10),
      shrinkWrap: true,
      itemCount: crew.length >= 4 ? 4 : crew.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crew[index].name,
              maxLines: 2,
              style: nameStyle,
            ),
            Text(
              crew[index].job,
              style: jobTilteStyle,
            ),
          ],
        );
      },
    );
  }
}
