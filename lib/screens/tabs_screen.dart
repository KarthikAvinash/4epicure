import '../screens/add_recipe_screen.dart';
import '../screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/models_provider.dart';
import 'chat_screen.dart';
import 'drawer.dart';
import 'grocery_screen.dart';
import 'recipe_with_pie_chart.dart';

import '../models/meal.dart';
import '../screens/categories_screen.dart';
import '../screens/favourites_screen.dart';
import '../widgets/main_drawer.dart';

// class TabsScreen extends StatefulWidget {
//   @override
//   State<TabsScreen> createState() => _TabsScreenState();
// }

// class _TabsScreenState extends State<TabsScreen> {
//   List<Map<String, Object>> _pages = [];
//   int _selectedPageIndex = 0;

//   void _selectPage(int index) {
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }

//   void initState() {
//     _pages = [
//       {
//         'page': MyFlipCard(),
//         'title': 'Dont display this in app bar',
//       },
//       {
//         'page': ChatScreen(),
//         'title': 'Recipe Sage',
//       },
//       {
//         'page': CreateRecipeScreen(),
//         'title': 'Add recipe',
//       },
//       {
//         'page': GroceryScreen(),
//         'title': 'My Groceries',
//       },
//       {
//         'page': NavScreen(),
//         'title': 'Youtube screen',
//       }
//     ];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ModelsProvider()),
//       ],
//       child: Scaffold(
//         appBar: _selectedPageIndex == 0 || _selectedPageIndex == 1
//             ? null
//             : AppBar(
//                 title: Text(_pages[_selectedPageIndex]['title'] as String),
//               ),
//         drawer: MyDrawer(),
//         body: _pages[_selectedPageIndex]['page'] as Widget,
//         bottomNavigationBar: BottomNavigationBar(
//           onTap: _selectPage,
//           backgroundColor: Theme.of(context).primaryColor,
//           unselectedItemColor: Colors.black,
//           selectedItemColor: Theme.of(context).accentColor,
//           currentIndex: _selectedPageIndex,
//           type: BottomNavigationBarType.shifting,
//           // fixedColor: Colors.amber, // added this line
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.local_dining),
//               activeIcon: Icon(
//                 Icons.local_dining,
//               ),
//               label: 'Recipes',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.star),
//               activeIcon: Icon(
//                 Icons.star,
//               ),
//               label: 'Recipe Sage',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add_circle_outline),
//               activeIcon: Icon(
//                 Icons.add_circle,
//               ),
//               label: 'add post',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               activeIcon: Icon(
//                 Icons.shopping_cart,
//               ),
//               label: 'My Groceries',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.play_circle_filled),
//               activeIcon: Icon(
//                 Icons.play_circle_filled,
//               ),
//               label: 'youtube',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//________________NEW___________
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'chat_screen.dart';
import 'grocery_screen.dart';
import 'recipe_with_pie_chart.dart';
import '../widgets/main_drawer.dart';
import 'nav_screen.dart';

class ShakeToNavigate extends StatefulWidget {
  @override
  _ShakeToNavigateState createState() => _ShakeToNavigateState();
}

class _ShakeToNavigateState extends State<ShakeToNavigate> {
  bool _isShaking = false;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x.abs() > 20 || event.y.abs() > 20 || event.z.abs() > 20) {
        if (!_isShaking) {
          setState(() {
            _isShaking = true;
          });
          // Navigate to another screen
          if (_selectedPageIndex < 4) {
            setState(() {
              _selectedPageIndex++;
            });
          } else {
            setState(() {
              _selectedPageIndex = 0;
            });
          }
          // Wait for a moment before allowing another shake
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _isShaking = false;
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Stop listening to accelerometer events
    accelerometerEvents.drain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: _selectedPageIndex == 0
          ? AppBar(
              title: Text('Recipes'),
            )
          : null,
      body: [
        MyFlipCard(),
        ChatScreen(),
        CreateRecipeScreen(),
        GroceryScreen(),
        NavScreen(),
      ][_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        // fixedColor: Colors.amber, // added this line
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            activeIcon: Icon(
              Icons.local_dining,
            ),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            activeIcon: Icon(
              Icons.star,
            ),
            label: 'Recipe Sage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(
              Icons.add_circle,
            ),
            label: 'add post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            activeIcon: Icon(
              Icons.shopping_cart,
            ),
            label: 'My Groceries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled),
            activeIcon: Icon(
              Icons.play_circle_filled,
            ),
            label: 'youtube',
          ),
        ],
      ),
    );
  }
}
