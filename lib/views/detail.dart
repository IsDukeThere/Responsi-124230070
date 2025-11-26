import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/controller/detail_controller.dart';
import 'package:project_akhir/services/spaceflightnews_service.dart';
import 'package:project_akhir/views/favorit.dart';

class NewsDetail extends StatefulWidget {
  final String title;
  final int id;
  final String username;
  const NewsDetail({
    super.key,
    required this.id,
    required this.title,
    required this.username,
  });

  @override
  State<NewsDetail> createState() => _DetailState();
}

class _DetailState extends State<NewsDetail> {
  Box<Favorit>? watchlistBox;
  bool isSaved = false;
  bool boxReady = false;

  @override
  void initState() {
    super.initState();
    controller = DetailController(Spaceflightnews: spaceflightnews());
    _newsDetailFuture = controller.getMovieDetail(widget.id);

    _openUserBox();
  }

  Future<void> _openUserBox() async {
    watchlistBox = await Hive.openBox<Favorit>('watchlist_${widget.username}');
    _checkIfSaved();
    setState(() {});
  }

  void _checkIfSaved() {
    setState(() {
      isSaved = watchlistBox!.containsKey(widget.News.id);
    });
  }

  void _toggleWatchlist() async {
    if (isSaved) {
      watchlistBox!.delete(widget.News.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.News.title} dihapus dari Favorit")),
      );
    } else {
      watchlistBox!.put(widget.News.id, widget.News);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.News.title} ditambahkan ke Favorit")),
      );
    }

    _checkIfSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Film", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<NewsDetail>(
        future: _newsDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final movie = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network(
                      "https://image.tmdb.org/t/p/w500${movie.image}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 400,
                    ),
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 15),
                                SizedBox(width: 5),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    movie.overview,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jadwal Tayang:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Harga Tiket:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleWatchlist,
        label: Text(isSaved ? "Hapus dari Watchlist" : "Tambah ke Watchlist"),
        icon: Icon(isSaved ? Icons.check : Icons.add),
      ),
    );
  }
}
