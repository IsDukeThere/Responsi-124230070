import 'package:flutter/material.dart';
import 'package:project_akhir/controller/news_controller.dart';
import 'package:project_akhir/models/news.dart';
import 'package:project_akhir/services/spaceflightnews_service.dart';
import 'package:project_akhir/views/detail.dart';
import 'package:intl/intl.dart';
import 'package:project_akhir/views/login.dart';

String formatDate(String dateString) {
  if (dateString.isEmpty) return "-";
  final date = DateTime.parse(dateString);
  return DateFormat("dd MMM yyyy").format(date);
}

enum MovieViewMode { popular, byLanguage, search }

class Home extends StatefulWidget {
  final String username;
  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<Home> {
  late NewsController controller;
  List<News> news = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();

  MovieViewMode _currentMode = MovieViewMode.popular;

  @override
  void initState() {
    super.initState();
    controller = NewsController(spaceflightnews: Spaceflightnews());
    _news();
  }

  Future<void> _news() async {
    setState(() {
      _currentMode = MovieViewMode.popular;
      currentPage = 1;
    });

    final data = await controller.getMovies(page: currentPage);
    setState(() {
      news = data;
    });
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    currentPage++;
    List<News> data = [];

    try {
      if (_currentMode == MovieViewMode.popular) {
        data = await controller.getMovies(page: currentPage);
      }
    } catch (e) {
      print("Error loading more data: $e");
    }

    setState(() {
      news.addAll(data);
      isLoadingMore = false;
    });
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() => isSearching = false);
      await _news();
      return;
    }

    setState(() {
      isSearching = true;
      _currentMode = MovieViewMode.search;
      currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Halo, ${widget.username}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: searchController,
                  onChanged: searchMovies,
                  decoration: InputDecoration(
                    hintText: "Cari...",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),

      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
          return false;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _news,
                    child: Text("News"),
                  ),
                  SizedBox(width: 15),
                  // ElevatedButton.icon(
                  //   onPressed: ,
                  //   label: Text(
                  //     "Blogs",
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child
                  : GridView.builder(
                      padding: EdgeInsets.all(15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        final m = news[index];
                        return MovieCard(
                          title: m.title,
                          image: m.image,
                          newsSite: m.newsSite,
                          release: m.releaseDate,
                          id: m.id,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetail(
                                  id: m.id,
                                  title: m.title,
                                  username: widget.username,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            if (isLoadingMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final int id;
  final String title;
  final String image;
  final String newsSite;
  final String release;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.newsSite,
    required this.release,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                "https://image.tmdb.org/t/p/w500$image",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 280,
                    color: Colors.grey.shade800,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, StackTrace) => Container(
                  height: 280,
                  color: Colors.grey.shade700,
                  child: const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 15),
                        SizedBox(width: 5),
                        Spacer(),
                        Text(
                          formatDate(release),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
