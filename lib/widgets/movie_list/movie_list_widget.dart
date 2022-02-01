import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/domain/api_client/path_factories.dart';
import 'package:the_movie_db/widgets/movie_list/movie_list_model.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    context.read<MovieListWidgetModel>().setupLocale();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListWidgetModel>();

    model.snackBar = SnackBar(
      content: Text(model.exceptionMessage ?? 'Empty erroe text'),
      onVisible: () => model.loadMovies(),
      duration: const Duration(seconds: 5),
      // width: 280.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    return const _MovieListBodyWidget();
  }
}

class _MovieListBodyWidget extends StatelessWidget {
  const _MovieListBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _MovieListViewWidget(),
        _SearchFieldWidget(),
      ],
    );
  }
}

class _MovieListViewWidget extends StatelessWidget {
  const _MovieListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListWidgetModel>();
    return ListView.builder(
      controller: model.scrollController,
      padding: const EdgeInsets.only(top: 70),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: model.movies.length,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index) {
        model.loadNewPage(index);
        final movie = model.movies[index];
        final posterPath = movie.posterPath;

        Widget posterImage;

        if (posterPath != null) {
          try {
            posterImage =
                Image.network(PathFactories.createPosterPath(posterPath),
                    loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }, errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            });
          } catch (e) {
            posterImage = const SizedBox.shrink();
          }
        } else {
          posterImage = const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    posterImage,
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            movie.releaseDate,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => model.onTapMovie(index: index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchFieldWidget extends StatelessWidget {
  const _SearchFieldWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListWidgetModel>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onEditingComplete: () {},
        onChanged: (inputText) => model.searchMovies(inputText),
        decoration: InputDecoration(
          labelText: 'Поиск',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
