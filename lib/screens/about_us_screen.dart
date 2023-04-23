import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/team_member.dart';

class AboutUsScreen extends StatelessWidget {
  final List<TeamMember> _teamMembers = [
    TeamMember(
      name: 'Devarshi Dubey',
      photoUrl: 'https://i.imgur.com/qps3My1.jpg',
      favoriteRecipe: 'Butter Chicken',
      linkedinUrl: 'https://www.linkedin.com/in/devarshi-dubey/',
    ),
    TeamMember(
      name: 'Devesh Kumar',
      photoUrl: 'https://i.imgur.com/9Brq3Vo.jpg',
      favoriteRecipe: 'Virgin Mojito',
      linkedinUrl: 'https://www.linkedin.com/in/devesh-k-3730a8165/',
    ),
    TeamMember(
      name: 'Karthik Avinash',
      photoUrl: 'https://i.imgur.com/v4a8lbp.jpg',
      favoriteRecipe: 'Chocolate Cake',
      linkedinUrl: 'https://www.linkedin.com/in/karthik-avinash-04b51022b/',
    ),
    TeamMember(
      name: 'Sameed Yallur',
      photoUrl: 'https://i.imgur.com/gqF35vf.jpg',
      favoriteRecipe: 'Tandoor Chicken',
      linkedinUrl: 'https://www.linkedin.com/in/sameed-yallur-a2b8a9228/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4Epicure'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFB100), // ffb100
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Center(
              child: AnimatedText(),
            ),
            SizedBox(height: 40),
            ..._teamMembers.map((member) => TeamMember(
                  name: member.name,
                  photoUrl: member.photoUrl,
                  favoriteRecipe: member.favoriteRecipe,
                  linkedinUrl: member.linkedinUrl,
                )),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset(0, -0.05))
        .animate(CurvedAnimation(
            parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Text(
        'About Us',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}