import 'package:flutter_brickgame_9999/constants/value_constants.dart';

class DisplayCharacter {
  final List<List<int>> characterBuffer;
  CharacterOffset initialPosition;
  CharacterOffset currentPosition;
  CharacterOffset targetPosition;
  CharacterType characterType;
  CharacterPadding padding;

  bool get isPlayer => characterType == CharacterType.Player;
  bool get isEnemy => characterType == CharacterType.Enemy;

  DisplayCharacter({
    required this.characterBuffer,
    required this.characterType,
    required this.initialPosition,
    required this.targetPosition,
    required this.currentPosition,
    required this.padding,
  });

  factory DisplayCharacter.create(
      {required List<List<int>> characterBuffer,
      required CharacterOffset initialPosition,
      required CharacterType characterType,
      CharacterPadding? padding}) {
    return DisplayCharacter(
        padding: padding ?? CharacterPadding(),
        characterBuffer: characterBuffer,
        characterType: characterType,
        currentPosition: CharacterOffset(column: 0, row: 0),
        initialPosition: initialPosition,
        targetPosition: initialPosition);
  }

  int getCharacterTypeFiller() {
    switch (this.characterType) {
      case CharacterType.Player:
        return ValueConstants.PLAYER_FILLER;
      case CharacterType.Enemy:
        return ValueConstants.ENEMY_FILLER;

      case CharacterType.Bullet:
        return ValueConstants.BULLET_FILLER;

      case CharacterType.Environment:
        return ValueConstants.ENVIRONMENT_FILLER;
    }
  }
}

class CharacterOffset {
  int row;
  int column;

  @override
  String toString() {
    return "row: $row, column: $column";
  }

  CharacterOffset({this.row = 4, this.column = 4});
}

class CharacterPadding {
  final int top;
  final int bottom;
  final int left;
  final int right;

  CharacterPadding({
    this.bottom = 4,
    this.left = 0,
    this.right = 0,
    this.top = 4,
  });
}

enum CharacterType { Player, Enemy, Bullet, Environment }
