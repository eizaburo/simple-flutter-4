import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //hero
          Container(
            width: double.infinity,
            height: 180,
            color: Color(0xFFAAAAAA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text("ヒーローエリア",
                  style: TextStyle(color: Colors.white,fontSize: 16)),
                Text("ヒーローエリアのキャプション",
                  style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          //services
          SizedBox(height: 40),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 100,
            color: Color(0xFFAAAAAA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("サービスA",style: TextStyle(color: Colors.white)),
                Text("サービスAの説明",style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          //services
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 100,
            color: Color(0xFFAAAAAA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("サービスB",style: TextStyle(color: Colors.white)),
                Text("サービスBの説明",style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          //services
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 100,
            color: Color(0xFFAAAAAA),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("サービスC",style: TextStyle(color: Colors.white)),
                Text("サービスCの説明",style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
