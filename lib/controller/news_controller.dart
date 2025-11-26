import 'package:project_akhir/models/news.dart';
import 'package:project_akhir/services/spaceflightnews_service.dart';

class NewsController {
  final Spaceflightnews spaceflightnews;
  
  NewsController({
    required this.spaceflightnews
  });

  Future<List<News>> getMovies({int page = 1}) async {
    final movies = await spaceflightnews.getMovieData(page: page);
    return movies.map((movies) {
      return News(
        id: movies.id, 
        title: movies.title, 
        newsSite:  movies.newsSite, 
        image:  movies.image, 
        releaseDate:  movies.releaseDate, 
        );
    }).toList();
  }
}