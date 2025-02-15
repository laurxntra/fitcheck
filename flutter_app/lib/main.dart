import 'package:flutter/material.dart';
import 'pages/phone_login.dart';  // ✅ Make sure this file exists
import 'pages/otp_verification.dart'; // ✅ Make sure this file exists
import 'pages/home_page.dart'; // ✅ Make sure this file exists
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitCheck',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const PhoneLoginScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            currPage = index;
          });
        },
        children: [
          HomePage(),
          Center(child: Text('Search Page')),
          Center(child: Text('Camera Page')),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.home,
                color: currPage == 0
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(143, 143, 143, 1),
              ),
              onPressed: () {
                _pageController.jumpToPage(0);
                setState(() {
                  currPage = 0;
                });
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.search,
                color: currPage == 1
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(143, 143, 143, 1),
              ),
              onPressed: () {
                _pageController.jumpToPage(1);
                setState(() {
                  currPage = 1;
                });
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.camera,
                color: currPage == 2
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(143, 143, 143, 1),
              ),
              onPressed: () {
                _pageController.jumpToPage(2);
                setState(() {
                  currPage = 2;
                });
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.person,
                color: currPage == 3
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(143, 143, 143, 1),
              ),
              onPressed: () {
                _pageController.jumpToPage(3);
                setState(() {
                  currPage = 3;
                });
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
