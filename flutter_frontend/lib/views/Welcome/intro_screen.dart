import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/views/Login/login_screen.dart';
import 'components/login_signup_btn.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i("IntroScreen: Building Introduction Screen");
    return IntroductionScreen(
      allowImplicitScrolling: true,
      autoScrollDuration: 300000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "This is the first page!",
          image: const Center(
            child: Text("👋", style: TextStyle(fontSize: 100.0)),
          ),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(color: Colors.orange),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ),
        PageViewModel(
            title: "Title of custom body page",
            bodyWidget: SingleChildScrollView(
                child: SafeArea(
                    child: Column(
              mainAxisSize: MainAxisSize.min, // Added this line
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  fit: FlexFit.loose, // Changed from Expanded to Flexible
                  child: Text("👋", style: TextStyle(fontSize: 100.0)),
                ),
                Flexible(
                  fit: FlexFit.loose, // Changed from Expanded to Flexible
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: LoginAndSignupBtn(),
                      ),
                    ],
                  ),
                ),
              ],
            )))),
      ],
      onDone: () {
        logger.i("USER_ACTION: Clicked Login/Signup");
        Provider.of<AuthProvider>(context, listen: false).setIntroSeen();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      },
      done: const Text("Login/Signup",
          style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text("Skip"),
      onSkip: () {
        // You can also handle skip
        Provider.of<AuthProvider>(context, listen: false).setIntroSeen();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      },
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}
