import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_brickgame_9999/constants/characters_constants.dart';
import 'package:flutter_brickgame_9999/constants/sound_constants.dart';
import 'package:flutter_brickgame_9999/constants/value_constants.dart';
import 'package:flutter_brickgame_9999/models/display_character.dart';
import 'package:soundpool/soundpool.dart';

class DotMatrixController extends ChangeNotifier {
  List<List<int>> screenBuffer = List.generate(
      ValueConstants.MAX_ROW_SIZE,
      (index) => List.generate(ValueConstants.MAX_COLUMN_SIZE,
          (index) => ValueConstants.EMPTY_FILLER));

  StreamController<List<List<int>>> bufferStream = StreamController();

  bool _dragging = true;

  DisplayCharacter? _player;

  Map<int, DisplayCharacter> _enemies = {};
  Map<String, int> _soundIds = {};
  Soundpool? _pool;

  int _characterCount = 0;

  bool isSFXMuted = false;
  bool isCollided = false;
  bool actionPressed = false;

  init() {
    _registerSounds();
  }

  actionPressedDown() {
    actionPressed = true;
  }

  actionPressedUp() {
    actionPressed = false;
  }

  reset() {
    _player = null;
    screenBuffer = List.generate(
        ValueConstants.MAX_ROW_SIZE,
        (index) => List.generate(ValueConstants.MAX_COLUMN_SIZE,
            (index) => ValueConstants.EMPTY_FILLER));
    bufferStream.add(screenBuffer);
    _characterCount = 0;
    _enemies.clear();
    _registerSounds();
  }

  clearScreen() {
    screenBuffer = List.generate(
        ValueConstants.MAX_ROW_SIZE,
        (index) => List.generate(ValueConstants.MAX_COLUMN_SIZE,
            (index) => ValueConstants.EMPTY_FILLER));
    bufferStream.add(screenBuffer);
  }

  _registerSounds() async {
    if (_pool == null) {
      _pool = Soundpool.fromOptions(
          options: SoundpoolOptions(
        streamType: StreamType.music,
        maxStreams: 10,
      ));
    }
    _soundIds[SoundConstants.PLAYER_MOVEMENT] = await _pool!
        .load(await rootBundle.load('assets/audios/sfx/movement.wav'));
    _soundIds[SoundConstants.PLAYER_CRASH] =
        await _pool!.load(await rootBundle.load('assets/audios/sfx/crash.wav'));

    _soundIds[SoundConstants.INTRO_MUSIC] = await _pool!
        .load(await rootBundle.load('assets/audios/sfx/intro_music.wav'));
    _soundIds[SoundConstants.OUTRO_MUSIC] = await _pool!
        .load(await rootBundle.load('assets/audios/sfx/outro_music.wav'));
    _soundIds[SoundConstants.GET_READY] = await _pool!
        .load(await rootBundle.load('assets/audios/sfx/get_ready.wav'));
  }

  _playerMovementSFX() {
    if (!isSFXMuted) {
      _pool!.play(_soundIds[SoundConstants.PLAYER_MOVEMENT]!);
    }
  }

  bootText() async {
    for (int i = 0; i < 9; i++) {
      if (i % 2 == 0 && i < 3) {
        _addCharacterInBuffer(DisplayCharacter.create(
            characterBuffer: CharacterConstants.nine,
            initialPosition: CharacterOffset(row: 5, column: 0),
            characterType: CharacterType.Environment));
        _addCharacterInBuffer(DisplayCharacter.create(
            characterBuffer: CharacterConstants.nine,
            initialPosition: CharacterOffset(row: 11, column: 3),
            characterType: CharacterType.Environment));
        _addCharacterInBuffer(DisplayCharacter.create(
            characterBuffer: CharacterConstants.nine,
            initialPosition: CharacterOffset(row: 17, column: 6),
            characterType: CharacterType.Environment));
      } else if (i % 2 == 0 && i < 8) {
        _addCharacterInBuffer(DisplayCharacter.create(
            characterBuffer: CharacterConstants.n,
            initialPosition: CharacterOffset(row: 7, column: 5),
            characterType: CharacterType.Environment));
        _addCharacterInBuffer(DisplayCharacter.create(
            characterBuffer: CharacterConstants.i,
            initialPosition: CharacterOffset(row: 7, column: 1),
            characterType: CharacterType.Environment));
        _addCharacterInBuffer(DisplayCharacter.create(
            characterBuffer: CharacterConstants.one,
            initialPosition: CharacterOffset(row: 14, column: 3),
            characterType: CharacterType.Environment));
      } else {
        clearScreen();
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  introSequence() async {
    if (!isSFXMuted) {
      _pool!.play(_soundIds[SoundConstants.INTRO_MUSIC]!);
    }
    await snakeAnimation();
    await snakeAnimation(filler: ValueConstants.EMPTY_FILLER);
    await bootText();
    carRace();
  }

  carRace({bool resetBufferOnStart = true}) async {
    if (resetBufferOnStart) reset();
    isCollided = false;
    _player = null;

    bool enemySpawnPlaceSwitch = false;
    bool needNewEnemy = false;
    bool roadBrickSwitch = false;

    addPlayer(DisplayCharacter.create(
        characterBuffer: CharacterConstants.car,
        padding: CharacterPadding(left: 1, right: 1, bottom: 4, top: 4),
        initialPosition: CharacterOffset(column: 4, row: 20),
        characterType: CharacterType.Player));

    addEnemy(DisplayCharacter.create(
        characterBuffer: CharacterConstants.car,
        initialPosition: CharacterOffset(column: 6, row: 2),
        padding: CharacterPadding(left: 1, right: 1, bottom: 0, top: 0),
        characterType: CharacterType.Enemy));

    addEnemy(DisplayCharacter.create(
        characterBuffer: CharacterConstants.car,
        initialPosition: CharacterOffset(column: 1, row: 12),
        padding: CharacterPadding(left: 1, right: 1, bottom: 0, top: 0),
        characterType: CharacterType.Enemy));

    // addEnemy(DisplayCharacter.create(
    //     characterBuffer: CharacterConstants.car,
    //     initialPosition: CharacterOffset(column: 6, row: 13),
    //     padding: CharacterPadding(left: 1, right: 1, bottom: 0, top: 0),
    //     characterType: CharacterType.Enemy));
    if (!resetBufferOnStart) await Future.delayed(Duration(seconds: 4));

    if (!isSFXMuted) {
      _pool!.play(_soundIds[SoundConstants.GET_READY]!);
    }
    await Future.delayed(Duration(milliseconds: 1200));
    while (!isCollided) {
      await Future.delayed(Duration(milliseconds: actionPressed ? 50 : 200));

      for (int i = ValueConstants.SCREEN_BUFFER_BOTTOM_PADDING;
          i < ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD;
          i++) {
        if (i % 2 == 0) {
          screenBuffer[i][0] = roadBrickSwitch
              ? ValueConstants.ENVIRONMENT_FILLER
              : ValueConstants.EMPTY_FILLER;
          screenBuffer[i][ValueConstants.MAX_COLUMN_SIZE - 1] = roadBrickSwitch
              ? ValueConstants.ENVIRONMENT_FILLER
              : ValueConstants.EMPTY_FILLER;
        }
        if (i % 2 == 0) {
          screenBuffer[i + 1][0] = !roadBrickSwitch
              ? ValueConstants.ENVIRONMENT_FILLER
              : ValueConstants.EMPTY_FILLER;
          screenBuffer[i + 1][ValueConstants.MAX_COLUMN_SIZE - 1] =
              !roadBrickSwitch
                  ? ValueConstants.ENVIRONMENT_FILLER
                  : ValueConstants.EMPTY_FILLER;
        }
      }
      roadBrickSwitch = !roadBrickSwitch;

      _enemies.values.forEach((enemy) {
        _moveCharacter(MovePosition.DOWN, enemy);

        if (enemy.currentPosition.row ==
            ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD - 2) {
          needNewEnemy = true;
        }
      });

      if (needNewEnemy) {
        needNewEnemy = false;
        addEnemy(DisplayCharacter.create(
            characterBuffer: CharacterConstants.car,
            initialPosition:
                CharacterOffset(column: enemySpawnPlaceSwitch ? 6 : 1, row: 2),
            padding: CharacterPadding(left: 1, right: 1, bottom: 0, top: 0),
            characterType: CharacterType.Enemy));

        enemySpawnPlaceSwitch = !enemySpawnPlaceSwitch;
      }
      _enemies.removeWhere((key, enemy) =>
          enemy.currentPosition.row ==
          ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD);
      print(_enemies.values.length);
    }
    await Future.delayed(Duration(milliseconds: 900));
    isCollided = false;
    if (!isSFXMuted) {
      _pool!.play(_soundIds[SoundConstants.OUTRO_MUSIC]!);
    }
    await curtainAnimation();
    await curtainAnimation(filler: ValueConstants.EMPTY_FILLER);
    carRace();
  }

  Future<void> addPlayer(DisplayCharacter character) async {
    if (_player == null) {
      _registerSounds();
      if (character.characterType != CharacterType.Player)
        throw Future.error('CharacterType is not Player');
      _player = character;
      await _addCharacterInBuffer(character, detectCollision: false);
    }
  }

  Future<int?> addEnemy(DisplayCharacter character) async {
    if (character.characterType != CharacterType.Enemy)
      throw Future.error('CharacterType is not Enemy');
    _registerSounds();
    _characterCount++;
    _enemies[_characterCount] = character;
    await _addCharacterInBuffer(character, detectCollision: false);
    return _characterCount;
  }

  dragStop() => _dragging = false;

  Future<bool> movePlayer(MovePosition position,
      {int steps = 1, bool dragButton = false}) async {
    if (_player != null) {
      if (dragButton) {
        _dragging = true;
        while (_dragging) {
          bool result = await _moveCharacter(position, _player!);
          await Future.delayed(Duration(milliseconds: 10));
          if (result) _playerMovementSFX();
        }
      } else {
        _moveCharacter(position, _player!);
        _playerMovementSFX();
      }
    }
    return false;
  }

  Future<bool> _moveCharacter(
      MovePosition movePosition, DisplayCharacter character,
      {int steps: 1}) async {
    switch (movePosition) {
      case MovePosition.UP:
        {
          character.targetPosition.row = character.currentPosition.row - steps;
          character.targetPosition.column = character.currentPosition.column;
        }
        break;
      case MovePosition.DOWN:
        {
          character.targetPosition.row = character.currentPosition.row + steps;
          character.targetPosition.column = character.currentPosition.column;
        }
        break;
      case MovePosition.RIGHT:
        {
          character.targetPosition.row = character.currentPosition.row;
          character.targetPosition.column =
              character.currentPosition.column + steps;
        }
        break;
      case MovePosition.LEFT:
        {
          character.targetPosition.row = character.currentPosition.row;
          character.targetPosition.column =
              character.currentPosition.column - steps;
        }
        break;
    }
    return await _addCharacterInBuffer(character);
  }

  //Animations

  Future<bool> insideOutAnimation({int filler = 1}) async {
    int traversedRow = 14;
    int traversedColumn = 4;

    int wallSize = 0;

    String direction = 'b';

    for (int i = 0;
        i < (ValueConstants.MAX_COLUMN_SIZE + ValueConstants.MAX_ROW_SIZE + 2);
        i++) {
      for (int j = 0; j < wallSize; j++) {
        screenBuffer[traversedRow][traversedColumn] = filler;
        bufferStream.add(screenBuffer);
        await Future.delayed(Duration(milliseconds: 05));

        if (direction == 't') {
          traversedRow--;
        }
        if (direction == 'b') {
          traversedRow++;
        }
        if (direction == 'r') {
          traversedColumn++;
        }
        if (direction == 'l') {
          traversedColumn--;
        }

        if (traversedRow.isNegative) {
          traversedRow = 0;
          break;
        }
        if (traversedColumn.isNegative) {
          traversedColumn = 0;
          break;
        }
        if (traversedColumn > ValueConstants.MAX_COLUMN_SIZE - 1) {
          traversedColumn = ValueConstants.MAX_COLUMN_SIZE - 1;
          break;
        }
        if (traversedRow >
            ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD) {
          traversedRow = ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD;
          break;
        }
      }

      if (direction == 't') {
        direction = 'l';
      } else if (direction == 'b') {
        direction = 'r';
      } else if (direction == 'r') {
        direction = 't';
      } else if (direction == 'l') {
        direction = 'b';
      }
      if (i % 2 == 0) wallSize++;
    }

    return true;
  }

  Future<bool> curtainAnimation(
      {int filler = ValueConstants.ENVIRONMENT_FILLER}) async {
    int traversedRow = 4;
    int traversedColumn = 0;

    for (int i = 0;
        i < (ValueConstants.MAX_ROW_SIZE * ValueConstants.MAX_COLUMN_SIZE);
        i++) {
      if (traversedRow >= ValueConstants.MAX_ROW_SIZE - 1) {
        traversedRow = 0;
        traversedColumn++;
      }
      if (traversedColumn >= ValueConstants.MAX_COLUMN_SIZE) {
        traversedColumn = 0;
        traversedRow++;
      }

      screenBuffer[traversedRow][traversedColumn] = filler;
      traversedColumn++;

      await Future.delayed(Duration(milliseconds: 18));

      bufferStream.add(screenBuffer);
    }
    return true;
  }

  Future<bool> snakeAnimation(
      {int filler = ValueConstants.ANIMATION_FILLER}) async {
    int traversedRow = ValueConstants.SCREEN_BUFFER_TOP_PADDING;
    int traversedColumn = 0;
    int height = ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_PAD +
        ValueConstants.SCREEN_BUFFER_TOP_PADDING;
    int width = ValueConstants.MAX_COLUMN_SIZE - 1;
    int wallSize = 0;

    String direction = 'r';

    for (int i = 0;
        i <
            ((ValueConstants.SCREEN_BUFFER_ROW_SIZE_WITHOUT_PAD) *
                ValueConstants.MAX_COLUMN_SIZE);
        i++) {
      if (traversedColumn <= wallSize) {
        if (direction == 'l') {
          direction = 't';
          wallSize++;
        }

        if (traversedRow == (ValueConstants.MAX_ROW_SIZE - height)) {
          if (direction == 't') {
            direction = 'r';
          }
        }
      }

      if (traversedColumn >= width) {
        if (direction == 'r') {
          direction = 'd';
          height--;
        }
      }

      if (traversedRow >= height) {
        if (direction == 'd') {
          direction = 'l';
          width--;
        }
      }

      screenBuffer[traversedRow][traversedColumn] = filler;
      bufferStream.add(screenBuffer);

      await Future.delayed(Duration(milliseconds: 1));

      if (direction == 'r') {
        traversedColumn++;
      }
      if (direction == 'l') {
        traversedColumn--;
      }
      if (direction == 't') {
        traversedRow--;
      }
      if (direction == 'd') {
        traversedRow++;
      }
    }
    return true;
  }

  Future<bool> _addCharacterInBuffer(
    DisplayCharacter character, {
    bool detectCollision = true,
  }) async {
    if (character.targetPosition.row < ValueConstants.MAX_ROW_SIZE &&
        character.targetPosition.column < ValueConstants.MAX_COLUMN_SIZE) {
      for (int i = 0; i < character.characterBuffer.length; i++) {
        for (int j = 0; j < character.characterBuffer[0].length; j++) {
          //Move right
          if (character.targetPosition.column >
                  character.currentPosition.column &&
              character.targetPosition.column +
                      character.characterBuffer[0].length -
                      1 <
                  (ValueConstants.MAX_COLUMN_SIZE - character.padding.right)) {
            for (int dc = 0;
                dc <
                    character.targetPosition.column -
                        character.currentPosition.column;
                dc++) {
              screenBuffer[i + character.targetPosition.row]
                  [character.currentPosition.column + dc] = 0;
            }
            //Move left
          } else if (character.targetPosition.column <
              character.currentPosition.column) {
            int charLength = character.characterBuffer[0].length - 1;
            int toBeErasedColumn =
                character.currentPosition.column + charLength;

            if (toBeErasedColumn > charLength + character.padding.left) {
              for (int dc = 0;
                  dc <
                      character.currentPosition.column -
                          character.targetPosition.column;
                  dc++) {
                screenBuffer[i + character.targetPosition.row]
                    [toBeErasedColumn - dc] = 0;
              }
            } else {
              return false;
            }
            //Move Down
          } else if (character.targetPosition.row >
                  character.currentPosition.row &&
              character.currentPosition.row + character.characterBuffer.length <
                  ValueConstants.MAX_ROW_SIZE - character.padding.bottom) {
            for (int dc = 0;
                dc <
                    character.targetPosition.row -
                        character.currentPosition.row;
                dc++)
              screenBuffer[character.currentPosition.row + dc]
                  [j + character.targetPosition.column] = 0;

            //Move Up
          } else if (character.targetPosition.row <
              character.currentPosition.row) {
            int toBeErasedRow = i + character.currentPosition.row;
            if (toBeErasedRow > 0 + character.padding.top) {
              screenBuffer[toBeErasedRow][j + character.targetPosition.column] =
                  0;
            } else {
              return false;
            }
          } else {
            return false;
          }
          int newColumn = j + character.targetPosition.column;
          int newRow = i + character.targetPosition.row;

          if (!newRow.isNegative && !newColumn.isNegative) {
            if (detectCollision) {
              List collides = [];

              if (character.isPlayer) {
                collides.addAll([
                  ValueConstants.ENEMY_FILLER,
                  ValueConstants.BULLET_FILLER
                ]);
              } else if (character.isEnemy) {
                collides.addAll([
                  ValueConstants.PLAYER_FILLER,
                  ValueConstants.BULLET_FILLER
                ]);
              }

              if (collides.contains(screenBuffer[newRow][newColumn])) {
                print("Collision C$newColumn R$newRow");
                if (!isSFXMuted) {
                  _pool!.play(_soundIds[SoundConstants.PLAYER_CRASH]!);
                }
                isCollided = true;
                return false;
              }
            }

            screenBuffer[newRow][newColumn] = character.characterBuffer[i][j] *
                character.getCharacterTypeFiller();

            bufferStream.add(screenBuffer);
          } else {
            return false;
          }
        }
      }
      character.currentPosition.row = character.targetPosition.row;
      character.currentPosition.column = character.targetPosition.column;
      return true;
    } else {
      print("No");
      return false;
    }
  }
}

enum MovePosition { UP, DOWN, RIGHT, LEFT }
