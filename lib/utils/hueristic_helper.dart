import 'dart:math';

import 'package:my_slide_puzzle/controllers/puzzle_box_controller.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';

class HueristicHelper {
  int boxDimension = 4, tilesCount = 16;

  void solveIt(List<int> board, List<int> goal) {
    while(!_compareBoards(board, goal)) {
      board = _hueriaticNextState(board, goal);
    }
  }

  void solveIt2(List<PuzzleBoxController> board) {
    List<int> goal = List.generate(16, (index) => index + 1);

    List<int> board = [];
    List<PuzzleBoxController> newBoard = List.from(board);
    newBoard.sort((a, b) {
      return a.puzzleTileModel.currentX.compareTo(b.puzzleTileModel.currentX);
    });
    newBoard.sort((a, b) {
      if(a.puzzleTileModel.currentX != b.puzzleTileModel.currentX) return 0;
      return a.puzzleTileModel.currentY.compareTo(b.puzzleTileModel.currentY);
    });

    for (PuzzleBoxController element in newBoard) {
      board.add(element.puzzleTileModel.id);
    }

    while(!_compareBoards(board, goal)) {
      board = _hueriaticNextState(board, goal);

      List<PuzzleTileModel> list = [];
      board.forEach((element) {
        List<PuzzleBoxController> tiles= newBoard.where((element) => element.puzzleTileModel.id == element).toList();
        if(tiles.isNotEmpty) {
          PuzzleTileModel tempModel = tiles.first.puzzleTileModel;
          PuzzleTileModel puzzleTileModel1 = PuzzleTileModel(
            id: tempModel.id,

          );
          list.add(puzzleTileModel1);
        }
      });
    }
  }

  bool _compareBoards(List<int> board, List<int> goal) {
    bool isSame = true;

    if(board.length != tilesCount || board.length != goal.length) {
      isSame = false;
    }
    else {
      for(int i = 0; i < board.length; i++) {
        if(board[i] != goal[i]) {
          isSame = false;
          break;
        }
      }
    }

    return isSame;
  }

  List<int> _hueriaticNextState(List<int> board, List<int> goal) {
    List<List<int>> expectedStates = _getExpectedStates(board);
    if(expectedStates.isEmpty) return board;

    List<int> mahattanDistances = [];
    expectedStates.forEach((List<int> list) {
      int distance = _getMahattanDistance(list, goal);
      mahattanDistances.add(distance);
    });

    mahattanDistances.sort((a, b) => a.compareTo(b));

    int shortestDistance = mahattanDistances[0];
    int distanceCount = mahattanDistances.where((element) => element == shortestDistance).toList().length;

    return expectedStates.where((element) => _getMahattanDistance(element, goal) == shortestDistance).toList()[distanceCount > 1 ? Random().nextInt(distanceCount) : 0];
  }

  List<List<int>> _getExpectedStates(List<int> board) {
    Map<int, List<int>> map = {};

    for(int i = 0; i < tilesCount; i++) {
      map[i] = _getPreExpectedStates(i);
    }

    int pos = board.indexOf(0);
    List<int> moves = map[pos] ?? [];

    List<List<int>> expectedStates = [];

    moves.forEach((x) {
      List<int> tempBoard = List.from(board);

      //x = x + y;
      tempBoard[pos] = tempBoard[pos] + tempBoard[pos + x];

      //y = x - y;
      tempBoard[pos + x] = tempBoard[pos] - tempBoard[pos + x];

      //x = x - y;
      tempBoard[pos] = tempBoard[pos] - tempBoard[pos + x];

      expectedStates.add(tempBoard);
    });

    return expectedStates;
  }

  List<int> _getPreExpectedStates(int x) {
    List<int> list = [1, -1, boxDimension, -boxDimension];

    List<int> validList = [];

    list.forEach((int y) {
      if(0 <= x + y && x + y < 16) {
        if(y == 1 && [3, 7, 11, 15].contains(x)) {}
        else if(y == -1 && [0, 4, 8, 12].contains(x)) {}
        else {
          validList.add(y);
        }
      }
    });

    return validList;
  }

  int _getMahattanDistance(List<int> board, List<int> goal) {
    int distance = 0;

    board.forEach((int node) {
      if(node != 0) {
        int gdist = goal.indexOf(node) - board.indexOf(node);
        gdist = gdist * (gdist > 0 ? 1 : -1);
        int jump = gdist ~/ 4;
        int steps = gdist % 4;
        distance += jump + steps;
      }
    });

    return distance;
  }
}