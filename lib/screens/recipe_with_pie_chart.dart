import 'dart:convert';

import '../screens/drawer.dart';
import '../screens/recipe_detail_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../globals.dart';
import '../widgets/pie_graph.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';

class MyFlipCard extends StatefulWidget {
  const MyFlipCard({context, Key? key}) : super(key: key);
  @override
  State<MyFlipCard> createState() => _MyFlipCardState();
}

class _MyFlipCardState extends State<MyFlipCard> {
  final SearchBarController _searchBarController = SearchBarController();
  ScrollController _scrollController = ScrollController();
  bool _sensorActive = false;
  StreamSubscription<AccelerometerEvent>? _subscription;
  void _toggleSensor() {
    setState(() {
      _sensorActive = !_sensorActive;
    });
    if (_sensorActive) {
      _subscription = accelerometerEvents.listen((AccelerometerEvent event) {
        if (event.z > 9.0) {
          _scrollController.animateTo(
            _scrollController.offset + 100,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        } else if (event.z < 6.0) {
          _scrollController.animateTo(
            _scrollController.offset - 100,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _subscription?.cancel();
    }
  }

  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    if (_sensorActive) {
      _subscription = accelerometerEvents.listen((AccelerometerEvent event) {
        if (event.z > 8.0) {
          _scrollController.animateTo(
            _scrollController.offset + 100,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        } else if (event.z < 6.0) {
          _scrollController.animateTo(
            _scrollController.offset - 100,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _fetchRecipes({String? query}) async {
    print("=>>>>>>>>>>>>>>>>>>>>>$query");
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        query == null
            ? Uri.parse('https://recipenutrition.pythonanywhere.com/recipes')
            : Uri.parse(
                'https://recipenutrition.pythonanywhere.com/recipes/name/$query'),
        headers: <String, String>{
          // 'origin': '*',
          // 'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final responseData = json.decode(response.body) as List<dynamic>;
      print("@@@@@@@@@");
      print(responseData);
      final List<Map<String, dynamic>> newRecipes =
          responseData.map((recipeData) {
        return {
          'title': recipeData['title'],
          'short_description': recipeData['short_description'],
          'image_url': recipeData['image_url'],
          'description': recipeData['description'],
          'ingredients': recipeData['ingredients'],
          'steps_with_images': recipeData['steps_with_images'],
          'nutrition': recipeData['nutrition'],
          'cook_time': recipeData['cook_time'],
          'rating': recipeData['rating'],
        };
      }).toList();
      setState(() {
        recipes = newRecipes;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching recipes: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  final _searchController = TextEditingController();
  String _searchText = '';
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _subscription
        ?.cancel(); // cancel the subscription when disposing the widget
    super.dispose();
  }

  void _handleSearch() {
    _fetchRecipes(query: _searchText);
  }

  @override
  Widget build(BuildContext context) {
    final sHeight = MediaQuery.of(context).size.height;
    final sWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: isLight
          ? ThemeData(
              brightness: Brightness.light,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.white,
              ),
            )
          : ThemeData(
              brightness: Brightness.dark,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.white,
              ),
            ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleSensor,
          child: Icon(_sensorActive ? Icons.pause : Icons.play_arrow),
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchText = _searchController.text;
                _handleSearch();
              },
            ),
          ],
        ),
        body: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300] ?? Colors.grey,
                highlightColor: Colors.grey[100] ?? Colors.white,
                child: ListView.builder(
                  itemCount:
                      10, // or any other number of items you want to display
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 240,
                            color: Colors.black45,
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 16,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.black45,
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 12,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.black45,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              )
            : Stack(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: recipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return a FlipCard widget for each data item
                        return FlipCard(
                          direction: FlipDirection.HORIZONTAL,
                          // front of the card
                          front: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: sWidth * 0.9,
                              height: sHeight * 0.4,
                              decoration: BoxDecoration(
                                color: card_color,
                                borderRadius: BorderRadius.circular(16.0),
                                border: border_color,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Recipe Image
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              recipes[index]['image_url']),
                                        ),
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Recipe Title
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      recipes[index]['title'],
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                        color: Colors
                                            .black54, // Change the text color here
                                      ),
                                    ),
                                  ),
                                  // Ratings and Cooktime
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Ratings
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.thumb_up,
                                              color: Colors.blue,
                                              size: 20.0,
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              recipes[index]['rating']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Roboto',
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Cooktime
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              color: Colors.blue,
                                              size: 20.0,
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              recipes[index]['cook_time'],
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Roboto',
                                                color: Colors.black54,
                                              ),
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
                          // back of the card
                          back: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: sWidth * 0.9,
                              height: sHeight * 0.4,
                              decoration: BoxDecoration(
                                color: card_color,
                                borderRadius: BorderRadius.circular(16.0),
                                border: border_color,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Nutrition Info
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: getPieChart(
                                          context, recipes[index]['nutrition']),
                                    ),
                                  ),
                                  // Recipe Description
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      recipes[index]['short_description'],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Roboto',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  // Button to navigate to another screen
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.blue, // Background color
                                        onPrimary: Colors.white, // Text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ), // Rounded corners
                                        textStyle: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ), // Text style
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 8.0), // Button padding
                                      ),
                                      onPressed: () {
                                        print(recipes[index]
                                                ['steps_with_images']
                                            .runtimeType);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            // fullscreenDialog: true,
                                            builder: (context) => RecipePage(
                                                recipeName: recipes[index]
                                                    ['title'],
                                                description: recipes[index]
                                                    ['description'],
                                                ingredientsWithQty:
                                                    recipes[index]
                                                        ['ingredients'],
                                                recipeImage: recipes[index]
                                                    ['image_url'],
                                                recipeSteps: recipes[index]
                                                    ['steps_with_images']),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
