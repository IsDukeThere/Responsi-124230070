import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_akhir/models/blogs.dart';
import 'package:project_akhir/models/news.dart';
import 'package:project_akhir/views/detail.dart';

class Spaceflightnews {
  final String newsApiUrl = "https://api.spaceflightnewsapi.net/v4/articles";
  final String blogsApiUrl = "https://api.spaceflightnewsapi.net/v4/blogs";
  final String reportsApiUrl = "https://api.spaceflightnewsapi.net/v4/reports";

  Future<List<News>> getNewsData({int page = 1}) async {
    final url = "$newsApiUrl?";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final List news = data['results'];
      return news.map(
        (json) => News.fromJson(json)
        ).toList();
    } else {
      throw Exception("Gagal Mengambil Data");
    }
  }

  Future<NewsDetail> getNewsDetail(int id) async {
    final String detailApi = "$newsApiUrl/$id/";
    final response = await http.get(Uri.parse(detailApi));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengambil detail film dengan ID $id");
    }
  }

  Future<List<Blogs>> getBlogsData({int page = 1}) async {
    final url = "$blogsApiUrl?";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final List blog = data['results'];
      return blog.map(
        (json) => Blogs.fromJson(json)
        ).toList();
    } else {
      throw Exception("Gagal Mengambil Data");
    }
  }
  
}