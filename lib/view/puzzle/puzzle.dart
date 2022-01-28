import 'package:flutter/material.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';
import 'package:my_slide_puzzle/providers/puzzle_provider.dart';
import 'package:provider/provider.dart';

class Puzzle extends StatefulWidget {
  const Puzzle({Key? key}) : super(key: key);

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
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
              Text("${puzzleProvider.moves} Moves"),

              getPuzzleTilesGridWidget(puzzleProvider.tiles, puzzleProvider),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getButton("Suffle", () => puzzleProvider.suffle()),
                  getButton("Reorder", () => puzzleProvider.reorder()),
                  getButton("Init", () => puzzleProvider.initPuzzle()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getPuzzleTilesGridWidget(List<PuzzleTileModel> list, PuzzleProvider puzzleProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          children: list.map((e) => getPuzzleTileWIdget(e, puzzleProvider)).toList(),
        ),
      ),
    );
  }

  Widget getPuzzleTileWIdget(PuzzleTileModel model, PuzzleProvider puzzleProvider) {
    if(model.isEmptySpace) return const SizedBox();
    return InkWell(
      onTap: () {
        if(model.asset.isNotEmpty) {
          puzzleProvider.moveTile(model);
        }
      },
      child: Container(
        //child: Image.asset(model.asset),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(model.id, style: TextStyle(color: Colors.white, fontSize: 30),)),
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
}