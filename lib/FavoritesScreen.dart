import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<String> favoriteQuotes;
  final Function(String) onRemove;

  FavoritesScreen({required this.favoriteQuotes, required this.onRemove});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<String> favoriteQuotes;

  @override
  void initState() {
    super.initState();
    favoriteQuotes = List.from(widget.favoriteQuotes);
  }

  void _removeFromFavorites(String quote) {
    setState(() {
      favoriteQuotes.remove(quote);
    });
    widget.onRemove(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Favorite Quotes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: favoriteQuotes.length,
        itemBuilder: (context, index) {
          String quote = favoriteQuotes[index];
          return ListTile(
            title: Text(
              quote,
              style: TextStyle(fontSize: 18),
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                _removeFromFavorites(quote);
              },
            ),
          );
        },
      ),
    );
  }
}
