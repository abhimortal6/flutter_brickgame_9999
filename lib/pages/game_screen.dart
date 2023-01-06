import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brickgame_9999/constants/characters_constants.dart';
import 'package:flutter_brickgame_9999/models/display_character.dart';
import 'package:flutter_brickgame_9999/widgets/button_widget.dart';
import 'package:flutter_brickgame_9999/widgets/dot_matrix_controller.dart';
import 'package:flutter_brickgame_9999/widgets/dot_matrix_display.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  DotMatrixController controller = DotMatrixController();

  @override
  void initState() {
    // TODO: implement initState
    // _addPlayer();
    controller.init();
    super.initState();
  }

  _addPlayer() {
    controller.addPlayer(DisplayCharacter.create(
        characterBuffer: CharacterConstants.one,
        initialPosition: CharacterOffset(row: 17, column: 3),
        characterType: CharacterType.Player));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      // floatingActionButton: GestureDetector(
      //   onTapDown: (t) {
      //     controller.actionPressedDown();
      //   },
      //   onTapUp: (t) {
      //     controller.actionPressedUp();
      //   },
      //   child: AbsorbPointer(
      //     child: FloatingActionButton(
      //         child: Text("A"),
      //         onPressed: () async {
      //           controller.reset();
      //           _addPlayer();
      //         }),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                child: Align(child: DotMatrixDisplay(controller: controller))),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 80.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 200,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ButtonWidget(
                        title: "On/Off",
                        size: 16,
                        fontSize: 10,
                        onTapUp: () {
                          controller.introSequence();
                        },
                      ),
                      Expanded(child: Container()),
                      ButtonWidget(
                        title: "Start",
                        size: 16,
                        fontSize: 10,
                        onTapUp: () {
                          controller.movePlayer(MovePosition.LEFT);
                        },
                      ),
                      Expanded(child: Container()),
                      ButtonWidget(
                        title: "Sound",
                        size: 16,
                        fontSize: 10,
                        onTapUp: () {
                          controller.movePlayer(MovePosition.LEFT);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 180,
                          height: 205,
                          margin: EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ButtonWidget(
                                title: "Up",
                                onTapUp: () {
                                  controller.movePlayer(MovePosition.UP);
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ButtonWidget(
                                    title: "Left",
                                    onTapUp: () {
                                      controller.movePlayer(MovePosition.LEFT);
                                    },
                                  ),
                                  Expanded(child: Container()),
                                  ButtonWidget(
                                    title: "Right",
                                    onTapUp: () {
                                      controller.movePlayer(MovePosition.RIGHT);
                                    },
                                  ),
                                ],
                              ),
                              ButtonWidget(
                                title: "Down",
                                onTapUp: () {
                                  controller.movePlayer(MovePosition.DOWN);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: ButtonWidget(
                              title: "Rotate",
                              size: 80,
                              onTapUp: controller.actionPressedUp,
                              onTapDown: controller.actionPressedDown)),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: <Widget>[
                  //       GestureDetector(
                  //         child: Container(
                  //           color: Colors.blue,
                  //           padding: EdgeInsets.all(10.0),
                  //           child: Text(
                  //             "Car race",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //         onTapDown: (t) async {
                  //           controller.carRace();
                  //         },
                  //       ),
                  //       GestureDetector(
                  //         child: Container(
                  //           color: Colors.blue,
                  //           padding: EdgeInsets.all(10.0),
                  //           child: Text(
                  //             "Boot",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //         onTapDown: (t) async {
                  //           controller.introSequence();
                  //         },
                  //       ),
                  //       GestureDetector(
                  //         child: Container(
                  //           color: Colors.blue,
                  //           padding: EdgeInsets.all(10.0),
                  //           child: Text(
                  //             "Snake",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //         onTapDown: (t) async {
                  //           controller.insideOutAnimation();
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
