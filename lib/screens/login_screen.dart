import 'package:flutter/material.dart';
import 'package:linkedin_clone/screens/home_screen.dart';
import 'package:linkedin_clone/screens/signup_screen.dart';
import 'package:linkedin_clone/services/auth_methods.dart';
import 'package:linkedin_clone/utils/utils.dart';
import 'package:linkedin_clone/widgets/text_input.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isloading = true;

  Future<void> signinuser() async {
    setState(() {
      _isloading = false;
    });
    String res = await AuthMethods()
        .signInUser(_emailController.text, _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isloading = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Uperside
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 120,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                      },
                      child: const Text(
                        'Join now',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sign in',
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 20,
              ),
              //Input Fields

              TextInputBox(textController: _emailController, hintText: 'Email'),
              TextInputBox(
                  textController: _passwordController, hintText: 'Password'),

              //Button

              InkWell(
                onTap: signinuser,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: (_isloading) ? const Center(
                      child: Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )) : const Center(child: CircularProgressIndicator(color: Colors.white,),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}