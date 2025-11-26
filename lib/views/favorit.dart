import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/models/news.dart';

class Favorit extends StatefulWidget {
  final String username;
  const Favorit({super.key, required this.username});

  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  Future<Box<Favorit>>? favoritBox;

  @override
  void initState() {
    super.initState();
    favoritBox = Hive.openBox<Favorit>('watchlist_${widget.username}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<Favorit>>(
      future: favoritBox,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(
              "Terjadi kesalahan: ${snapshot.error}",
              style:TextStyle(color: Colors.white),
              )
            ),
          );
        }

    final box = snapshot.data!;
    return Scaffold(
      appBar: AppBar(title: Text("Favorit ${widget.username}",
      style: TextStyle(
        color: Colors.white
        ),
      )),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Favorit> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text(
              "Belum ada Favorit",
              style:TextStyle(color: Colors.white),
              )
            );
          }

          final news = box.values.toList();

          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final m = news[index];
              return ListTile(
                leading: Image.network(
                  "${m.image}",
                  fit: BoxFit.cover,
                ),
                title: Text(
                  m.title,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                subtitle: Text(
                  "News Site: ${m.newsSite}",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    box.delete(m.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  );
}
}