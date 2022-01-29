import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:my_slide_puzzle/controllers/puzzle_box_controller.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';

class PuzzleProvider extends ChangeNotifier {
  List<PuzzleBoxController> controllers = [];
  int moves = 0, unsolvedCount = 15;

  Future<void> initPuzzle({bool isNotify = true}) async {
    if(controllers.isNotEmpty) {
      for(int i = 0; i < controllers.length; i++) {
        PuzzleBoxController puzzleBoxController = controllers[i];
        puzzleBoxController.puzzleTileModel.currentX = puzzleBoxController.puzzleTileModel.originalX;
        puzzleBoxController.puzzleTileModel.currentY = puzzleBoxController.puzzleTileModel.originalY;
      }
    }
    else {
      int count = 0;
      for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
          if(i == 3 && j == 3) {}
          else {
            count++;
            PuzzleTileModel puzzleTileModel = PuzzleTileModel(
              id: count.toString(),
              asset1: "assets/images/dashatar/blue/${count}.png",
              asset2: "assets/images/dashatar/green/${count}.png",
              asset3: "assets/images/dashatar/yellow/${count}.png",
              originalX: j,
              originalY: i,
              currentX: j,
              currentY: i,
            );
            PuzzleBoxController puzzleBoxController = PuzzleBoxController(puzzleTileModel);
            controllers.add(puzzleBoxController);
          }
        }
      }

      PuzzleTileModel puzzleTileModel = PuzzleTileModel(
        id: "16",
        asset1: "",
        asset2: "",
        asset3: "",
        originalX: 3,
        originalY: 3,
        currentX: 3,
        currentY: 3,
        isEmptySpace: true,
      );
      PuzzleBoxController puzzleBoxController = PuzzleBoxController(puzzleTileModel);
      controllers.add(puzzleBoxController);
    }

    moves = 0;

    if(isNotify) notifyListeners();
    await Future.delayed(controllers.first.duration);
  }

  Future<void> suffle() async {
    if(controllers.isEmpty) {
      await initPuzzle(isNotify: false);
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

      PuzzleTileModel puzzleTileModel = controllers[i].puzzleTileModel;
      puzzleTileModel.currentX = tempX;
      puzzleTileModel.currentY = tempY;
      used[tempX][tempY] = true;
    }
    notifyListeners();
    await Future.delayed(controllers.first.duration);
  }

  Future<void> reorder() async {
    if(controllers.isEmpty) {
      await initPuzzle(isNotify: true);
    }
    else {
      controllers.forEach((element) {
        element.puzzleTileModel.currentX = element.puzzleTileModel.originalX;
        element.puzzleTileModel.currentY = element.puzzleTileModel.originalY;
      });
      notifyListeners();
      await Future.delayed(controllers.first.duration);
    }
  }

  Future restartGame() async {
    Duration waitDuration = const Duration(milliseconds: 170);

    moves = 0;
    await suffle();
    await Future.delayed(waitDuration);
    await suffle();
    await Future.delayed(waitDuration);
    await suffle();
  }

  void moveTile(PuzzleBoxController puzzleBoxController) {
    print("moveTile called");
    List<PuzzleBoxController> list = controllers.where((element) => element.puzzleTileModel.isEmptySpace).toList();
    if(list.isNotEmpty) {
      PuzzleBoxController whiteSpaceModelCntroller = list.first;

      //To Check If Move is Valid Or Not
      if(puzzleBoxController.puzzleTileModel.currentX == whiteSpaceModelCntroller.puzzleTileModel.currentX || puzzleBoxController.puzzleTileModel.currentY == whiteSpaceModelCntroller.puzzleTileModel.currentY) {
        print("valid");
        int deltaY = whiteSpaceModelCntroller.puzzleTileModel.currentX - puzzleBoxController.puzzleTileModel.currentX;
        int deltaX = whiteSpaceModelCntroller.puzzleTileModel.currentY - puzzleBoxController.puzzleTileModel.currentY;

        print("DeltaX:${deltaX}");
        print("DeltaY:${deltaY}");

        if(deltaY == 0) {
          List<PuzzleBoxController> compoentsBetweenStartAndEnd = controllers.where((element) => deltaX > 0
              ? (element.puzzleTileModel.currentY > puzzleBoxController.puzzleTileModel.currentY && element.puzzleTileModel.currentY < whiteSpaceModelCntroller.puzzleTileModel.currentY && element.puzzleTileModel.currentX == puzzleBoxController.puzzleTileModel.currentX)
              : (element.puzzleTileModel.currentY > whiteSpaceModelCntroller.puzzleTileModel.currentY && element.puzzleTileModel.currentY < puzzleBoxController.puzzleTileModel.currentY && element.puzzleTileModel.currentX == puzzleBoxController.puzzleTileModel.currentX)).toList();
          print("Y Components Between Length:${compoentsBetweenStartAndEnd.length}");
          compoentsBetweenStartAndEnd.forEach((element) {
            element.puzzleTileModel.currentY = element.puzzleTileModel.currentY + (deltaX > 0 ? 1 : -1);
          });
          whiteSpaceModelCntroller.puzzleTileModel.currentY = puzzleBoxController.puzzleTileModel.currentY;
          puzzleBoxController.puzzleTileModel.currentY = puzzleBoxController.puzzleTileModel.currentY + (deltaX > 0 ? 1 : -1);
        }
        else {
          List<PuzzleBoxController> compoentsBetweenStartAndEnd = controllers.where((element) => deltaY > 0
              ? (element.puzzleTileModel.currentX > puzzleBoxController.puzzleTileModel.currentX && element.puzzleTileModel.currentX < whiteSpaceModelCntroller.puzzleTileModel.currentX && element.puzzleTileModel.currentY == puzzleBoxController.puzzleTileModel.currentY)
              : (element.puzzleTileModel.currentX > whiteSpaceModelCntroller.puzzleTileModel.currentX && element.puzzleTileModel.currentX < puzzleBoxController.puzzleTileModel.currentX && element.puzzleTileModel.currentY == puzzleBoxController.puzzleTileModel.currentY)).toList();
          print("X Components Between Length:${compoentsBetweenStartAndEnd.length}");
          compoentsBetweenStartAndEnd.forEach((element) {
            element.puzzleTileModel.currentX = element.puzzleTileModel.currentX + (deltaY > 0 ? 1 : -1);
          });
          whiteSpaceModelCntroller.puzzleTileModel.currentX = puzzleBoxController.puzzleTileModel.currentX;
          puzzleBoxController.puzzleTileModel.currentX = puzzleBoxController.puzzleTileModel.currentX + (deltaY > 0 ? 1 : -1);
        }

        unsolvedCount = 0;

        controllers.forEach((element) {
          if(element.puzzleTileModel.currentX != element.puzzleTileModel.originalX || element.puzzleTileModel.currentY != element.puzzleTileModel.originalY) {
            unsolvedCount++;
          }
        });

        moves++;
      }
    }
    notifyListeners();
  }

  /*bool _isValidToMove(PuzzleTileModel puzzleTileModel) {
    bool isValid = false;

    List<PuzzleTileModel> list = tiles.where((element) => element.isEmptySpace).toList();
    if(list.isNotEmpty) {
      PuzzleTileModel whiteSpaceModel = list.first;
      if(puzzleTileModel.currentX == whiteSpaceModel.currentX || puzzleTileModel.currentY == whiteSpaceModel.currentY) isValid = true;
    }

    return isValid;
  }*/

  /*void sort() {
      tiles.sort((a, b) {
        return a.currentX.compareTo(b.currentX);
      });
      tiles.sort((a, b) {
        if(a.currentX != b.currentX) return 0;
        return a.currentY.compareTo(b.currentY);
      });
      notifyListeners();
    }*/
}