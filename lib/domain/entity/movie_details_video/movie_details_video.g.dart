// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsVideo _$MovieDetailsVideoFromJson(Map<String, dynamic> json) =>
    MovieDetailsVideo(
      results: (json['results'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieDetailsVideoToJson(MovieDetailsVideo instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
