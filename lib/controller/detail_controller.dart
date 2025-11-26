import 'package:project_akhir/services/spaceflightnews_service.dart';
import 'package:project_akhir/views/detail.dart';

class DetailController {
  final Spaceflightnews spaceflightnews;

  DetailController({required this.spaceflightnews});

  Future<NewsDetail> getMovieDetail(int id) async {
    return await spaceflightnews.getMovieDetail(id);
  }
}