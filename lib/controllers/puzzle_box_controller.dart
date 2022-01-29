import 'package:flutter/cupertino.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';

class PuzzleBoxController extends ChangeNotifier {
  PuzzleTileModel puzzleTileModel;

  PuzzleBoxController(this.puzzleTileModel);
}