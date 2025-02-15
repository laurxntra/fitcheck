import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/FitCheck.png', 
           height: 100,
        ),
        
      ),
      // will have to connect images from storage to here at some point!!
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.accents[index % Colors.accents.length],
            child: Center(
              child: Text(
                'Item $index',
                style: TextStyle(fontSize: 24, color: Colors.white),
              )
            )
          );
        },
      )
    );
  }
}
