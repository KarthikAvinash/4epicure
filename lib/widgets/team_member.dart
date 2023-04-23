import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMember extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String favoriteRecipe;
  final String linkedinUrl;

  const TeamMember({
    Key? key,
    required this.name,
    required this.photoUrl,
    required this.favoriteRecipe,
    required this.linkedinUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: NetworkImage(photoUrl),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Favorite recipe: $favoriteRecipe',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              if (await canLaunch(linkedinUrl)) {
                await launch(linkedinUrl);
              } else {
                throw 'Could not launch $linkedinUrl';
              }
            },
            child: Text(
              'Linkedin Profile',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}