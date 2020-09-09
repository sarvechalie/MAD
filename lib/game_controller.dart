import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/components/enemy.dart';
import 'package:game/components/healthbar.dart';
import 'package:game/components/highscoreText.dart';
import 'package:game/components/player.dart';
import 'package:game/components/score_text.dart';
import 'package:game/components/start_text.dart';
import 'package:game/enemy_spawner.dart';
import 'package:game/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends Game {
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  List<Enemy> enemies;
  EnemySpawner enemySpawner;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  final SharedPreferences storage;
  States state;
  HighscoreText highscoreText;
  StartText startText;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = States.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    healthBar = HealthBar(this);
    enemySpawner = EnemySpawner(this);
    spawnEnemy();
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xDD000000);
    c.drawRect(background, backgroundPaint);
    player.render(c);
    if (state == States.menu) {
      startText.render(c);
      highscoreText.render(c);
    } else {
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == States.menu) {
      startText.update(t);
      highscoreText.update(t);
    } else if (state == States.playing) {
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      healthBar.update(t);
      scoreText.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == States.menu) {
      state = States.playing;
    } else if (state == States.playing) {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        // top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        // right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        // bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        // left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }

  /*void changeState() {
    if (state == States.menu) {
      state = States.playing;
    } else if (state == States.playing) {
      state = States.menu;
    }
  }*/
}
