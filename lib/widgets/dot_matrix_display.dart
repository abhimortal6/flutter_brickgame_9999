import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_brickgame_9999/constants/value_constants.dart';
import 'package:flutter_brickgame_9999/controllers/dot_matrix_controller.dart';
import 'package:flutter_brickgame_9999/widgets/brick_widget.dart';

class DotMatrixDisplay extends StatefulWidget {
  const DotMatrixDisplay({required this.controller, Key? key})
      : super(key: key);

  final DotMatrixController controller;

  @override
  _DotMatrixDisplayState createState() => _DotMatrixDisplayState();
}

class _DotMatrixDisplayState extends State<DotMatrixDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<List<int>>>(
        stream: widget.controller.bufferStream.stream,
        initialData: widget.controller.screenBuffer,
        builder: (context, snapshot) {
          List<List<int>>? screenData = snapshot.data as List<List<int>>;

          return snapshot.data == null
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1)),
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Color(0xec9ead86),
                      width: 260,
                      height: 320,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            width: 15 * (ValueConstants.MAX_COLUMN_SIZE + 0.5),
                            height: 15 *
                                (ValueConstants
                                        .SCREEN_BUFFER_ROW_SIZE_WITHOUT_PAD +
                                    0.5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = ValueConstants
                                        .SCREEN_BUFFER_TOP_PADDING;
                                    i <
                                        ValueConstants
                                            .SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD;
                                    i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      for (int j = 0;
                                          j < ValueConstants.MAX_COLUMN_SIZE;
                                          j++)
                                        BrickWidget(
                                          isBrickOn: [
                                            ValueConstants.PLAYER_FILLER,
                                            ValueConstants.ENEMY_FILLER,
                                            ValueConstants.ENVIRONMENT_FILLER,
                                            ValueConstants.BULLET_FILLER,
                                            ValueConstants.ANIMATION_FILLER,
                                          ].contains(screenData[i][j]),
                                          isDebug: screenData[i][j] ==
                                              ValueConstants.DEBUG_FILLER,
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
