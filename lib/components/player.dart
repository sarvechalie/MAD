import 'dart:ui';

import 'package:game/game_controller.dart';

class Player {
  final GameController gameController;
  int maxHealth;
  int currentHealth;
  Rect rect;
  RRect player;
  bool isDead = false;

  Player(this.gameController) {
    maxHealth = 300;
    currentHealth = 300;
    final size = gameController.tileSize * 1.5;
    rect = Rect.fromLTWH(gameController.screenSize.width / 2 - size / 2,
        gameController.screenSize.height / 2 - size / 2, size, size);
    player = RRect.fromRectAndRadius(rect, Radius.circular(15));
  }
  void render(Canvas c) {
    Paint color = Paint()..color = Color(0xFF0000FF);
    c.drawRRect(player, color);
  }

  void update(double t) {
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }
}
