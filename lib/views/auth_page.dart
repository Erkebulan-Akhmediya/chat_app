import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool _signUp = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();

  Widget _username() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: _usernameController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _email() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.mail),
          labelText: 'Email Address',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _password() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        obscureText: true,
        controller: _passwordController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.password),
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _verifyPassword() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        obscureText: true,
        controller: _verifyPasswordController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.password_outlined),
          labelText: 'Verify Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _signUpHandler() async {
    try {
      // verify password
      if (_passwordController.text != _verifyPasswordController.text) {
        throw FirebaseAuthException(
          message: 'Password verification failed',
          code: 'operation-not-allowed',
        );
      }

      UserService userService = Provider.of<UserService>(context, listen: false);

      // authenticate user
      UserCredential userCredential = await Provider
          .of<AuthService>(context, listen: false)
          .signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // save user to db
      await userService.saveUser(
        ChatUser(
          id: userCredential.user!.uid,
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );

    } on FirebaseAuthException catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Sign up failed'),
        ),
      );
    }
  }

  Widget _signUpButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: ElevatedButton(
        onPressed: _signUpHandler,
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return SizedBox(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () async {
          await Provider.of<AuthService>(context, listen: false).signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
        },
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _alreadyHaveAccount() {
    return TextButton(
      onPressed: () {
        setState(() {
          _signUp = false;
        });
      },
      child: const Text('Already have an account? Sign In'),
    );
  }

  Widget _dontHaveAccount() {
    return TextButton(
      onPressed: () {
        setState(() {
          _signUp = true;
        });
      },
      child: const Text('Don\'t have an account? Sign Up'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            const Icon(Icons.lock, size: 60.0,),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, top: 10.0),
              child: Text(
                _signUp ? 'Sign Up' : 'SignIn',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            _signUp ? _username() : Container(),
            _email(),
            _password(),
            _signUp ? _verifyPassword() : Container(),
            _signUp ? _signUpButton() : _signInButton(),
            _signUp ? _alreadyHaveAccount() : _dontHaveAccount(),
          ],
        ),
      ),
    );
  }
}