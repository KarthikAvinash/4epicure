import 'package:flutter/material.dart';
import '../screens/recipe_detail_screen.dart';
import 'pie_graph.dart';

class RecipeListView extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;
  final int user_id;
  RecipeListView({required this.recipes, required this.user_id});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return FadeInRecipeCard(
          recipe: recipe,
          onTap: () {
            print(recipe['steps_with_images'].runtimeType);
            Navigator.push(
              context,
              MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (context) => RecipePage(
                    recipeName: recipe['title'],
                    description: recipe['description'],
                    ingredientsWithQty: recipe['ingredients'],
                    recipeImage: recipe['image_url'],
                    recipeSteps: recipe['steps_with_images']),
              ),
            );
          },
        );
      },

    );
  }
}

class FadeInRecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onTap;
  const FadeInRecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);
  @override
  _FadeInRecipeCardState createState() => _FadeInRecipeCardState();
}

class _FadeInRecipeCardState extends State<FadeInRecipeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );
  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  widget.recipe['image_url'],
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe['title'], // front
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.recipe['short_description'], // front
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.recipe['cook_time']} mins', //front
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${widget.recipe['rating']}', // front
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    getPieChart(context, widget.recipe['nutrition']),
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

/*
ListView.builder(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                                          Icons.star,
                                          color: Colors.blue,
                                          size: 20.0,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          recipes[index]['rating'].toString(),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'Roboto',
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
*/