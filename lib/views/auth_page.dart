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
    return TextField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
      ),
    );
  }

  Widget _email() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email Address',
      ),
    );
  }

  Widget _password() {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
    );
  }

  Widget _verifyPassword() {
    return TextField(
      controller: _verifyPasswordController,
      decoration: const InputDecoration(
        labelText: 'Verify Password',
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
    return ElevatedButton(
      onPressed: _signUpHandler,
      child: const Text('Sign Up'),
    );
  }

  Widget _signInButton() {
    return ElevatedButton(
      onPressed: () async {
        await Provider.of<AuthService>(context, listen: false).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      },
      child: const Text('Sign In'),
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
      body: Column(
        children: <Widget>[
          _signUp ? _username() : Container(),
          _email(),
          _password(),
          _signUp ? _verifyPassword() : Container(),
          _signUp ? _signUpButton() : _signInButton(),
          _signUp ? _alreadyHaveAccount() : _dontHaveAccount(),
        ],
      ),
    );
  }
}