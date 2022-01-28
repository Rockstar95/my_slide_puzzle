import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';

class PuzzleProvider extends ChangeNotifier {
  List<PuzzleTileModel> tiles = [];
  int moves = 0;

  void initPuzzle({bool isNotify = true}) {
    tiles.clear();
    int count = 0;
    for(int i = 0; i < 4; i++) {
      for(int j = 0; j < (i == 3 ? 3 : 4); j++) {
        count++;
        PuzzleTileModel puzzleTileModel = PuzzleTileModel(
          id: count.toString(),
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
      id: "16",
      asset: "",
      originalX: 3,
      originalY: 3,
      currentX: 3,
      currentY: 3,
      isEmptySpace: true,
    );
    tiles.add(puzzleTileModel);

    moves = 0;

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
    print("moveTile called");
    List<PuzzleTileModel> list = tiles.where((element) => element.isEmptySpace).toList();
    if(list.isNotEmpty) {
      PuzzleTileModel whiteSpaceModel = list.first;

      //To Check If Move is Valid Or Not
      if(puzzleTileModel.currentX == whiteSpaceModel.currentX || puzzleTileModel.currentY == whiteSpaceModel.currentY) {
        print("valid");
        int deltaX = whiteSpaceModel.currentX - puzzleTileModel.currentX;
        int deltaY = whiteSpaceModel.currentY - puzzleTileModel.currentY;

        if(deltaX == 0) {
          List<PuzzleTileModel> compoentsBetweenStartAndEnd = tiles.where((element) => deltaY > 0
              ? (element.currentY > puzzleTileModel.currentY && element.currentY < whiteSpaceModel.currentY && element.currentX == puzzleTileModel.currentX)
              : (element.currentY > whiteSpaceModel.currentY && element.currentY < puzzleTileModel.currentY && element.currentX == puzzleTileModel.currentX)).toList();
          print("Components Between Length:${compoentsBetweenStartAndEnd.length}");
          compoentsBetweenStartAndEnd.forEach((element) {
            element.currentY = element.currentY + (deltaY > 0 ? 1 : -1);
          });
          whiteSpaceModel.currentY = puzzleTileModel.currentY;
          puzzleTileModel.currentY = puzzleTileModel.currentY + (deltaY > 0 ? 1 : -1);
        }
        else {
          List<PuzzleTileModel> compoentsBetweenStartAndEnd = tiles.where((element) => deltaX > 0
              ? (element.currentX > puzzleTileModel.currentX && element.currentX < whiteSpaceModel.currentX && element.currentY == puzzleTileModel.currentY)
              : (element.currentX > whiteSpaceModel.currentX && element.currentX < puzzleTileModel.currentX && element.currentY == puzzleTileModel.currentY)).toList();
          print("Components Between Length:${compoentsBetweenStartAndEnd.length}");
          compoentsBetweenStartAndEnd.forEach((element) {
            element.currentX = element.currentX + (deltaX > 0 ? 1 : -1);
          });
          whiteSpaceModel.currentX = puzzleTileModel.currentX;
          puzzleTileModel.currentX = puzzleTileModel.currentX + (deltaX > 0 ? 1 : -1);
        }

        moves++;
        sort();
      }
    }
  }

  bool _isValidToMove(PuzzleTileModel puzzleTileModel) {
    bool isValid = false;

    List<PuzzleTileModel> list = tiles.where((element) => element.isEmptySpace).toList();
    if(list.isNotEmpty) {
      PuzzleTileModel whiteSpaceModel = list.first;
      if(puzzleTileModel.currentX == whiteSpaceModel.currentX || puzzleTileModel.currentY == whiteSpaceModel.currentY) isValid = true;
    }

    return isValid;
  }
}