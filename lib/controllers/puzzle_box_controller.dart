import 'package:flutter/cupertino.dart';
import 'package:my_slide_puzzle/models/puzzle_tile_model.dart';

class PuzzleBoxController {
  Duration duration = Duration(milliseconds: 400);
  PuzzleTileModel puzzleTileModel;
  PuzzleBoxController(this.puzzleTileModel);
}