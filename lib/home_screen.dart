import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quote_of_the_day/constraint.dart';
import 'package:quote_of_the_day/quotes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import 'FavoritesScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? imageList;
  int? imageNumber = 0;
  var accessKey = 'YibJMjdy8HTp662Wtxlh6Q-AWAS-Ep1455R6vfVsWvc';
  List<String> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    getImagesFromUnsplash();
    loadFavorites();
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs.getStringList('favorites') ?? [];
      print("Favorites Loaded: $favoriteQuotes");
    });
  }

  void saveToFavorites(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!favoriteQuotes.contains(quote)) {
        favoriteQuotes.add(quote);
      } else {
        favoriteQuotes.remove(quote);
      }
    });
    await prefs.setStringList('favorites', favoriteQuotes);
    print("Favorite Quotes Updated: $favoriteQuotes");
  }

  void shareQuote(String quote) {
    Share.share(quote);
  }

  void removeFromFavorites(String quote) {
    setState(() {
      favoriteQuotes.remove(quote);
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('favorites', favoriteQuotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Quote of the Day',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteQuotes: favoriteQuotes,
                    onRemove: removeFromFavorites,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: imageList != null
          ? Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: BlurHash(
              key: ValueKey(imageList![imageNumber!]['blur_hash']),
              hash: imageList![imageNumber!]['blur_hash'],
              duration: Duration(milliseconds: 500),
              image: imageList![imageNumber!]['urls']['regular'],
              curve: Curves.easeInOut,
              imageFit: BoxFit.cover,
            ),
          ),
          Container(
            width: width,
            height: height,
            color: Colors.black54,
          ),
          Container(
            width: width,
            height: height,
            child: SafeArea(
              child: CarouselSlider.builder(
                itemCount: quotesList.length,
                itemBuilder: (context, index1, index2) {
                  String quote = quotesList[index1][kQuote];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          quote,
                          style: kQuoteTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          quotesList[index1][kAuthor],
                          style: kAuthorTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              favoriteQuotes.contains(quote)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteQuotes.contains(quote)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            onPressed: () {
                              saveToFavorites(quote);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: () {
                              shareQuote(quote);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, value) {
                    HapticFeedback.lightImpact();
                    imageNumber = index;
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        width: width,
        height: height,
        color: Colors.black54,
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void getImagesFromUnsplash() async {
    var url =
        'https://api.unsplash.com/search/photos?page=30&query=nature&order_by=relevent&client_id=$accessKey';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    print(response.statusCode);
    var unsplashData = json.decode(response.body);
    imageList = unsplashData['results'];
    setState(() {});
    print(unsplashData);
  }
}
