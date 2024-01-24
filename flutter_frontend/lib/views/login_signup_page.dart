import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => EmailValidator.validate(value ?? '') ? null : 'Please enter a valid email',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value != null && value.length >= 6 ? null : 'Password must be at least 6 characters',
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _login(context),
                child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _errorMessage = null;

      // TODO: Implement your login logic here.
      // Example: await myAuthService.login(_emailController.text, _passwordController.text);
      // On successful login, navigate to the main page:
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HabitListView()));

      // Example error handling:
      try {
        // Simulate a login call
        await Future.delayed(Duration(seconds: 2));
        // On success:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HabitListView()));
      } catch (error) {
        // On failure:
        setState(() {
          _errorMessage = 'Failed to log in. Please try again.';
          _isLoading = false;
        });
      }
    }
  }
}
