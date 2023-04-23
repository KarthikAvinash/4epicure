import 'signUp.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../utilities/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // route name
  // static const routeName = '/login';

  //controllers
  final nameController =
      TextEditingController(); //Anything that isn't known at compile time should be final over const.
  final passwordController = TextEditingController();

  final authServices authservices = authServices();

  void signIn() {
    authservices.signInUser(
      context: context,
      name: nameController.text,
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
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: sHeight * 0.03,
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
                      "Welcome back! Glad to see you, Again!",
                      style: TextStyle(
                        color: blackish,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          
                // TextField-name
                SizedBox(
                  height: sHeight * 0.1,
                  width: sWidth * 0.9,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
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
                      hintText: "Enter your password",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: blackish),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                    ),
                    obscureText: true,
                  ),
                ),
          
                // Forgot? Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () => {
                            
                                },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: darkGray, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
          
                //Login Button
                Container(
                  height: sHeight * 0.08,
                  width: sWidth * 0.9,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ElevatedButton(
                    onPressed: signIn,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            blackish)), // remember to give the color in this format otherwise null safety error will be prompted
                    child: const Text(
                      "Login",
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
                        "---------------------- Or login With ----------------------",
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
                    const Text("Dont have an account?"),
                    TextButton(
                        onPressed: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen())),
                            },
                        child: const Text(
                          "Register now?",
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
