import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {required this.title,
      this.onLongPressStart,
      this.onLongPressStop,
      this.onTapDown,
      this.onTapUp,
      this.size = 45,
      this.fontSize = 12,
      Key? key})
      : super(key: key);

  final String title;
  final Function? onTapDown;
  final Function? onTapUp;
  final Function? onLongPressStart;
  final Function? onLongPressStop;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            height: size,
            width: size,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
            padding: EdgeInsets.all(10.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ),
        ],
      ),
      onTapDown: (t) async {
        if (onTapDown != null) {
          onTapDown!();
        }
      },
      onTapUp: (t) {
        if (onTapUp != null) {
          onTapUp!();
        }
      },
      onLongPressStart: (l) async {
        if (onLongPressStart != null) {
          onLongPressStart!();
        }
      },
      onLongPressEnd: (l) {
        if (onLongPressStop != null) {
          onLongPressStop!();
        }
      },
    );
  }
}
