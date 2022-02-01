import 'package:the_movie_db/domain/api_client/configuration_api_client.dart';

class PathFactories {
  static String createPosterPath(String posterPath) {
    return ConfigurationApiClient.imageUrl + posterPath;
  }
}
