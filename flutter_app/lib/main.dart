import 'package:flutter/material.dart';
import 'pages/phone_login.dart';  // ✅ Make sure this file exists
import 'pages/otp_verification.dart'; // ✅ Make sure this file exists
import 'pages/home_page.dart'; // ✅ Make sure this file exists

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
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
              onPressed: (){
                setState(() {
                  currPage = 0;
                });
              }
              ),
              
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.search,
                color: currPage == 1 
                ? Color.fromRGBO(255, 255, 255, 1)
                : Color.fromRGBO(143, 143, 143, 1),
              ), 
              onPressed: (){
                setState(() {
                  currPage = 1;
                });
              }
              ),

            Spacer(),
            IconButton(
              icon: Icon(
                Icons.camera,
                color: currPage == 2 
                ? Color.fromRGBO(255, 255, 255, 1)
                : Color.fromRGBO(143, 143, 143, 1),
              ), 
              onPressed: (){
                setState(() {
                  currPage = 2;
                });
              }
              ),
  
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.person,
                color: currPage == 3 
                ? Color.fromRGBO(255, 255, 255, 1)
                : Color.fromRGBO(143, 143, 143, 1),
              ), 
              onPressed: (){
                setState(() {
                  currPage = 3;
                });
              }
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }

}


