class PuzzleTileModel {
  int id = 0, originalX = 0, originalY = 0, currentX = 0, currentY = 0;
  String asset1 = "", asset2 = "", asset3 = "";
  bool isEmptySpace = false;

  PuzzleTileModel({
    this.id = 0, this.originalX = 0, this.originalY = 0, this.currentX = 0, this.currentY = 0,
    this.asset1 = "", this.asset2 = "", this.asset3 = "",
    this.isEmptySpace = false,
  });
}