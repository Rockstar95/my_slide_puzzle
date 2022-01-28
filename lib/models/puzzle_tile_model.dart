class PuzzleTileModel {
  int originalX = 0, originalY = 0, currentX = 0, currentY = 0;
  String id = "", asset = "";
  bool isEmptySpace = false;

  PuzzleTileModel({
    this.originalX = 0, this.originalY = 0, this.currentX = 0, this.currentY = 0,
    this.id = "", this.asset = "",
    this.isEmptySpace = false,
  });
}