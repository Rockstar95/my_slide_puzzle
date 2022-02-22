import 'package:flutter/material.dart';
import 'package:my_slide_puzzle/view/puzzle/puzzle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNumbers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Puzzle(isShowNumbers: isNumbers,)),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Show Numbers"),
                Switch(value: isNumbers, onChanged: (value) {
                  isNumbers = value;
                  setState(() {});
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
