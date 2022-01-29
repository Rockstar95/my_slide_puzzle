import 'package:flutter/material.dart';
import 'package:my_slide_puzzle/controllers/puzzle_box_controller.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';
import 'package:my_slide_puzzle/providers/puzzle_provider.dart';
import 'package:my_slide_puzzle/view/puzzle/components/puzzle_tile_widget.dart';
import 'package:provider/provider.dart';

class Puzzle extends StatefulWidget {
  bool isShowNumbers;
  final String assetName;

  Puzzle({Key? key, this.isShowNumbers = false, this.assetName = "blue"}) : super(key: key);

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  bool isFirst = true;

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PuzzleProvider()),
      ],
      builder: (BuildContext context, Widget? child) {
        return Consumer<PuzzleProvider>(
          builder: (BuildContext context, PuzzleProvider puzzleProvider, Widget? child) {
            if(isFirst) {
              isFirst = false;
              puzzleProvider.initPuzzle(isNotify: false);
            }

            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("${puzzleProvider.moves} Moves | ${puzzleProvider.unsolvedCount} Tiles"),
                  const SizedBox(height: 10,),
                  getPuzzleTilesGridWidget((MediaQuery.of(context).size.width * 0.9).toInt(), puzzleProvider.controllers),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getButton("Restart", () async {
                        await puzzleProvider.restartGame();
                      }),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getButton("Suffle", () async {
                        await puzzleProvider.suffle();
                      }),
                      getButton("Reorder", () async {
                        await puzzleProvider.reorder();
                      }),
                      getButton("Init", () async {
                        await puzzleProvider.initPuzzle();
                      }),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Visibility(
                    visible: !widget.isShowNumbers,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getAssetButton("assets/images/dashatar/gallery/blue.png", () async {
                          setState(() {
                            selectedIndex = 0;
                          });
                        }, selectedIndex == 0),
                        getAssetButton("assets/images/dashatar/gallery/green.png", () async {
                          setState(() {
                            selectedIndex = 1;
                          });
                        }, selectedIndex == 1),
                        getAssetButton("assets/images/dashatar/gallery/yellow.png", () async {
                          setState(() {
                            selectedIndex = 2;
                          });
                        }, selectedIndex == 2),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget getPuzzleTilesGridWidget(int size, List<PuzzleBoxController> list) {
    return Center(
      child: Container(
        width: size.toDouble(),
        height: size.toDouble(),
        child: Stack(
          children: list.map((e) => PuzzleTileWidget(puzzleBoxController: e, size: size~/4, isShowNumber: widget.isShowNumbers, selectedImageIndex: selectedIndex,)).toList(),
        ),
      ),
    );
  }

  Widget getButton(String text, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16),),
      ),
    );
  }

  Widget getAssetButton(String assetPath, Function onTap, bool isSelected) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: isSelected ? 80 : 70,
        width: isSelected ? 80 : 70,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset(assetPath),
      ),
    );
  }
}