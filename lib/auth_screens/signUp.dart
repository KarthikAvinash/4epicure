import 'signIn.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../utilities/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // route name
  // var routeName = '/';

  final authServices authservices = authServices();

  //controllers
  final emailController =
      TextEditingController(); //Anything that isn't known at compile time should be final over const.
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void signup() {
    authservices.signUpUser(
      context: context,
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    //dynamic sizes
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
            child: Center(
          // understand this part thoroughly
          child: SingleChildScrollView
          (
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: sHeight * 0.01,
                ),
          
                // back icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
          
                SizedBox(
                  height: sHeight * 0.03,
                ),
          
                // Welcome Back text
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: SizedBox(
                    height: sHeight * 0.2,
                    child: const Text(
                      "Hello! Register to get Started",
                      style: TextStyle(
                        color: blackish,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          
                // email
                SizedBox(
                  height: sHeight * 0.1,
                  width: sWidth * 0.9,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "name",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: blackish),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                  ),
                ),
          
                // TextField-email
                SizedBox(
                  height: sHeight * 0.1,
                  width: sWidth * 0.9,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: blackish),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                  ),
                ),
          
                // Maybe Used for spacing but now i think the padding of the text field is handling this
                // SizedBox(
                //   height: sHeight*0.05,
                // ),
          
                // Textfield-password
                SizedBox(
                  height: sHeight * 0.1,
                  width: sWidth * 0.9,
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: blackish),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                    obscureText: true,
                  ),
                ),
          
                //Register Button
                Container(
                  height: sHeight * 0.08,
                  width: sWidth * 0.9,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ElevatedButton(
                    onPressed: signup,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            blackish)), // remember to give the color in this format otherwise null safety error will be prompted
                    child: const Text(
                      "Register",
                      style: TextStyle(color: darkOrange),
                    ),
                  ),
                ),
          
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sHeight * 0.03,
                    ),
                  ],
                ),
          
                //Or login with Sized Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: sHeight * 0.05,
                      child: const Text(
                        "---------------------- Or Register With ----------------------",
                        style: TextStyle(
                          color: blackish,
                        ),
                      ),
                    ),
                  ],
                ),
          
                // Login with google Button
                Container(
                  height: sHeight * 0.08,
                  width: sWidth * 0.35,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors
                            .white)), // remember to give the color in this format otherwise null safety error will be prompted
                    child: const Image(
                      image: AssetImage("assets/images/google.png"),
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
          
                SizedBox(
                  height: sHeight * 0.02,
                ),
          
                //Dont have an account?Register now
                Row(
                  // height:sHeight * 0.3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen())),
                            },
                        child: const Text(
                          "Login now?",
                          style: TextStyle(color: darkGreen),
                        )),
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
