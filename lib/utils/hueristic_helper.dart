import 'dart:math';

class HueristicHelper {
  int boxDimension = 4, tilesCount = 16;

  void solveIt(List<int> board, List<int> goal) {
    while(!_compareBoards(board, goal)) {
      board = _hueriaticNextState(board, goal);
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