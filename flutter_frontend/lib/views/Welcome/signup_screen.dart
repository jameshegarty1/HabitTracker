import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup(BuildContext context) async {
    if (_passwordController.text == _confirmPasswordController.text) {
      final result = await Provider.of<AuthProvider>(context, listen: false)
        .signup(_usernameController.text, _passwordController.text, "test@test.com");

      if (result['success'])  {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful! Logging in...')),
        );
        Navigator.of(context).pushReplacementNamed('/home');

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );      }
    } else {
      // Show an error if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _signup(context),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
