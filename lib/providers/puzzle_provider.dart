import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';

class PuzzleProvider extends ChangeNotifier {
  List<PuzzleTileModel> tiles = [];

  void initPuzzle({bool isNotify = true}) {
    tiles.clear();
    int count = 0;
    for(int i = 0; i < 4; i++) {
      for(int j = 0; j < (i == 3 ? 3 : 4); j++) {
        count++;
        PuzzleTileModel puzzleTileModel = PuzzleTileModel(
          id: i.toString()+j.toString(),
          asset: "assets/images/dashatar/blue/${count}.png",
          originalX: i,
          originalY: j,
          currentX: i,
          currentY: j,
        );
        tiles.add(puzzleTileModel);
      }
    }

    PuzzleTileModel puzzleTileModel = PuzzleTileModel(
      id: "33",
      asset: "",
      originalX: 3,
      originalY: 3,
      currentX: 3,
      currentY: 3,
    );
    tiles.add(puzzleTileModel);

    if(isNotify) notifyListeners();
  }

  void suffle() {
    if(tiles.isEmpty) {
      initPuzzle(isNotify: false);
    }

    List<List<bool>> used = List.generate(4, (index) => List.generate(4, (index) => false));

    Random random = Random();
    for(int i = 0; i < 16; i++) {
      int tempX = random.nextInt(4);
      int tempY = random.nextInt(4);

      while(used[tempX][tempY] == true) {
        tempX = random.nextInt(4);
        tempY = random.nextInt(4);
      }

      PuzzleTileModel puzzleTileModel = tiles[i];
      puzzleTileModel.currentX = tempX;
      puzzleTileModel.currentY = tempY;
      used[tempX][tempY] = true;
    }

    sort();
  }

  void sort() {
    tiles.sort((a, b) {
      return a.currentX.compareTo(b.currentX);
    });
    tiles.sort((a, b) {
      if(a.currentX != b.currentX) return 0;
      return a.currentY.compareTo(b.currentY);
    });
    notifyListeners();
  }

  void reorder() {
    if(tiles.isEmpty) {
      initPuzzle(isNotify: true);
    }
    else {
      tiles.forEach((element) {
        element.currentX = element.originalX;
        element.currentY = element.originalY;
      });
      sort();
      notifyListeners();
    }
  }

  void moveTile(PuzzleTileModel puzzleTileModel) {

  }
}