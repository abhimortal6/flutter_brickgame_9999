class ValueConstants {
  static const int MAX_ROW_SIZE = 28;
  static const int MAX_COLUMN_SIZE = 10;
  static const int SCREEN_BUFFER_TOP_PADDING = 4;
  static const int SCREEN_BUFFER_BOTTOM_PADDING = 4;
  static const int SCREEN_BUFFER_ROW_SIZE_WITHOUT_PAD =
      MAX_ROW_SIZE - SCREEN_BUFFER_TOP_PADDING - SCREEN_BUFFER_BOTTOM_PADDING;
  static const int SCREEN_BUFFER_ROW_SIZE_WITHOUT_HALF_PAD =
      MAX_ROW_SIZE - SCREEN_BUFFER_TOP_PADDING;

  static const int EMPTY_FILLER = 0;
  static const int PLAYER_FILLER = 1;
  static const int ENEMY_FILLER = 2;
  static const int ENVIRONMENT_FILLER = 3;
  static const int BULLET_FILLER = 4;
  static const int ANIMATION_FILLER = 5;
  static const int DEBUG_FILLER = 99;
}
