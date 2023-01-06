import 'package:flutter/material.dart';

class BrickWidget extends StatefulWidget {
  BrickWidget({Key? key, this.isBrickOn: true, this.isDebug: false})
      : super(key: key);

  final bool isBrickOn;
  final bool isDebug;

  @override
  _BrickWidgetState createState() => _BrickWidgetState();
}

class _BrickWidgetState extends State<BrickWidget> {
  Color _onColor = Colors.black87;
  Color _offColor = Colors.black12.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: 15,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 40),
        decoration: BoxDecoration(
            border: Border.all(color: widget.isBrickOn ? _onColor : _offColor)),
        padding: EdgeInsets.all(1.3),
        margin: EdgeInsets.all(1.5),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 120),
          color: widget.isDebug
              ? Colors.red
              : widget.isBrickOn
                  ? _onColor
                  : _offColor,
        ),
      ),
    );
  }
}
