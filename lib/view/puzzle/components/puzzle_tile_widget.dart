import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_slide_puzzle/controllers/puzzle_box_controller.dart';
import 'package:my_slide_puzzle/providers/puzzle_provider.dart';
import 'package:provider/provider.dart';

class PuzzleTileWidget extends StatefulWidget {
  PuzzleBoxController puzzleBoxController;
  int size, selectedImageIndex = 0;
  bool isShowNumber = false;
  PuzzleTileWidget({Key? key, required this.puzzleBoxController, required this.size, this.isShowNumber = false, this.selectedImageIndex = 0}) : super(key: key);

  @override
  _PuzzleTileWidgetState createState() => _PuzzleTileWidgetState();
}

class _PuzzleTileWidgetState extends State<PuzzleTileWidget> {
  @override
  Widget build(BuildContext context) {
    //print("Build Called");

    PuzzleProvider puzzleProvider = Provider.of(context, listen: false);

    print("Id:${widget.puzzleBoxController.puzzleTileModel.id}, X:${widget.puzzleBoxController.puzzleTileModel.currentX}, Y:${widget.puzzleBoxController.puzzleTileModel.currentY}");

    if(widget.puzzleBoxController.puzzleTileModel.isEmptySpace) return const SizedBox();

    String imagePath = "";
    if(widget.selectedImageIndex == 0) {
      imagePath = widget.puzzleBoxController.puzzleTileModel.asset1;
    }
    else if(widget.selectedImageIndex == 1) {
      imagePath = widget.puzzleBoxController.puzzleTileModel.asset2;
    }
    else {
      imagePath = widget.puzzleBoxController.puzzleTileModel.asset3;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: (widget.puzzleBoxController.puzzleTileModel.currentY * widget.size).toDouble(),
      left: (widget.puzzleBoxController.puzzleTileModel.currentX * widget.size).toDouble(),
      child: InkWell(
        onTap: () {
          if(!widget.puzzleBoxController.puzzleTileModel.isEmptySpace) {
            puzzleProvider.moveTile(widget.puzzleBoxController);
          }
        },
        child: SizedBox(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            //child: Center(child: Text(widget.puzzleBoxController.puzzleTileModel.id, style: const TextStyle(color: Colors.white, fontSize: 30),)),
            child: widget.isShowNumber
              ? Center(child: Text(widget.puzzleBoxController.puzzleTileModel.id, style: const TextStyle(color: Colors.white, fontSize: 30),))
              : Image.asset(imagePath),
          ),
        ),
      ),
    );
  }
}
