// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/widgets/movie_list/movie_list_model.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);

    if (model == null) {
      return const Center(
        child: Text('Модель не найдена'),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          controller: model.scrollController,
          padding: EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: model.movies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = model.movies[index];
            final posterPath = movie.posterPath;
            final releaseDate = movie.releaseDate;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        posterPath != null
                            ? Image.network(
                                ApiClient.createPosterPath(posterPath))
                            : SizedBox.shrink(),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                movie.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                releaseDate != null
                                    ? model.dateFormat.format(releaseDate)
                                    : '', 
                                style: TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20),
                              Text(
                                movie.overview,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () =>
                          model.onTapMovie(context: context, index: index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Поиск',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
