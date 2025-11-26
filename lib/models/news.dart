import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class News {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String newsSite;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String releaseDate;

  News({
    required this.id,
    required this.title,
    required this.newsSite,
    required this.image,
    required this.releaseDate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'] ?? '',
      newsSite: json['news_site'] ?? '',
      image: json['image_url'] ?? '',
      releaseDate: json['published_at'] ?? '',
    );
  }

  static Future? getMovieData() async {}
}
