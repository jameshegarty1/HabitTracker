import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/main.dart';
import 'package:flutter_frontend/views/Welcome/login_screen.dart';
import 'package:flutter_frontend/views/Welcome/auth_option_screen.dart';

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
          body: "This is the second page!", // Added a body text
          // Alternatively, use bodyWidget for more custom content:
          // bodyWidget: Widget(),
        ),
      ],
      onDone: () {
        logger.i("USER_ACTION: Clicked Login/Signup");
        // To clear intro page uncomment:
        //Provider.of<AuthProvider>(context, listen: false).setIntroSeen();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AuthOptionScreen()),
        );
      },
      done: const Text("Login/Signup",
          style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text("Skip"),
      onSkip: () {
        // To clear intro page uncomment:
        //Provider.of<AuthProvider>(context, listen: false).setIntroSeen();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AuthOptionScreen()),
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
