import 'dart:math';
import 'package:game_2048/components/gameTile.dart';
import 'package:game_2048/enums/movingDirection.dart';
import 'package:game_2048/game.dart';
import 'package:game_2048/models/setting_score.dart';
import 'package:game_2048/models/tileModel.dart';
import 'package:flame/extensions.dart';
import 'package:get/get.dart';

class GameModel {
  int cols, rows;
  List<List<GameTile>> gameTiles = [];
  Game2048 gameRef;
  bool gameChanged = false;
  int currentScore = 0, currentMaxTileValue = 0;
  late final SettingsAndScoreModel settingsAndScoreModel;
  GameModel({required this.cols, required this.rows, required this.gameRef}) {
    List<GameTile> tempList = [];
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        tempList.add(GameTile(
            size: Vector2(gameRef.size.x * .9 / 5, gameRef.size.x * .9 / 5),
            tileModel: TileModel(value: 0),
            tilePosition: Vector2(
                gameRef.bgTopLeftCorner.x +
                    (j + 1) * (gameRef.bg.size.x / 5 + gameRef.bg.size.x / 25),
                gameRef.bgTopLeftCorner.y +
                    (i + 1) *
                        (gameRef.bg.size.y / 5 + gameRef.bg.size.y / 25))));
      }
      gameTiles.add(tempList);
      tempList = [];
    }
    fillRandomTile(isFirstStart: true);
    initialize();
  }

  void merge({required MovingDirection mergingDirection}) async {
    List<GameTile> columnList = [];
    switch (mergingDirection) {
      case MovingDirection.Right:
        for (var i = 0; i < rows; i++) {
          await mergeTileList(
              tileList: this.gameTiles[i].reversed.toList(),
              mergingDirection: MovingDirection.Right);
        }
        break;
      case MovingDirection.Left:
        for (var i = 0; i < rows; i++) {
          await mergeTileList(
              tileList: this.gameTiles[i],
              mergingDirection: MovingDirection.Left);
        }
        break;
      case MovingDirection.Down:
        for (var i = 0; i < cols; i++) {
          for (var j = 0; j < rows; j++) {
            columnList.add(gameTiles[j][i]);
          }
          await mergeTileList(
              tileList: columnList.reversed.toList(),
              mergingDirection: MovingDirection.Down);
          columnList = [];
        }
        break;
      default:
        for (var i = 0; i < cols; i++) {
          for (var j = 0; j < rows; j++) {
            columnList.add(gameTiles[j][i]);
          }
          await mergeTileList(
              tileList: columnList, mergingDirection: MovingDirection.Up);
          columnList = [];
        }
        break;
    }
    if (gameChanged) {
      Future.delayed(Duration(milliseconds: 100)).then((value) async {
        fillRandomTile();
        gameChanged = false;
        await saveScore();

        // printTilesValues();
      });
    }
  }

  Future<void> initialize() async {
    settingsAndScoreModel = await Get.find<SettingsAndScoreModel>();
  }

  Future<void> addTileToGame() async {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        await gameRef.add(gameTiles[i][j]);
      }
    }
  }

  Future<void> mergeTileList(
      {required List<GameTile> tileList, required mergingDirection}) async {
    await reorderTileList(
        tileList: tileList, movingDirection: mergingDirection);
    for (int i = 0; i < tileList.length - 1; i++) {
      if (!tileList[i].isEmpty()) {
        await tileList[i].mergeWithTile(
            movingDirection: mergingDirection,
            gameTile: tileList[i + 1],
            onMerging: () => gameChanged = true);
        currentMaxTileValue = tileList[i].tileModel.value > currentMaxTileValue
            ? tileList[i].tileModel.value
            : currentMaxTileValue;
      }
    }
    await reorderTileList(
        tileList: tileList, movingDirection: mergingDirection);
    await reorderTileList(
        tileList: tileList, movingDirection: mergingDirection);
    for (var i = 0; i < tileList.length - 1; i++) tileList[i].reset();
    // print("After reordering : ${gameChanged}");
  }

  bool swapTileModels({required GameTile tile1, required GameTile tile2}) {
    TileModel tempTileModel = tile1.tileModel;
    tile1.tileModel = tile2.tileModel;
    tile2.tileModel = tempTileModel;
    tile1.updateColors();
    tile2.updateColors();
    return true;
  }

  Future<void> reorderTileList(
      {required List<GameTile> tileList,
      required MovingDirection movingDirection}) async {
    // printTilesList(tileList: tileList);
    for (int i = 0; i < tileList.length; i++) {
      if (tileList[i].isEmpty()) {
        for (int j = i + 1; j < tileList.length; j++) {
          if (!tileList[j].isEmpty()) {
            if (i != 0)
              await tileList[i].moveTile(
                  direction: movingDirection,
                  onCompleted: () {
                    // print("Moving the tile from the reorder function");
                  });
            gameChanged = true;
            swapTileModels(tile1: tileList[i], tile2: tileList[j]);
            break;
          }
        }
      }
    }
    // printTilesList(tileList: tileList);
  }

  bool isListNonOrdered({required List<GameTile> listToCheck}) {
    int idOfFirst = -1;
    for (var i = 0; i < listToCheck.length; i++) {
      if (listToCheck[i].isEmpty()) {
        if (idOfFirst == -1)
          idOfFirst = i;
        else {
          if (i - idOfFirst > 1) return false;
        }
      }
    }
    return true;
  }

  void printTilesValues() {
    String string = "";
    for (var i = 0; i < rows; i++) {
      string += "[ ";
      for (var j = 0; j < cols; j++) {
        string += "${gameTiles[i][j].tileModel.value}, ";
      }
      string += "]\n";
    }
    print("tiles value are :\n $string");
  }

  void fillRandomTile({bool isFirstStart = false}) {
    Random rand = Random();
    print("Filling a random tile");
    List<GameTile> emptyTiles = [];
    for (var i = 0; i < rows; i++) {
      emptyTiles.addAll(gameTiles[i].where((tile) => tile.isEmpty()));
    }
    int indexToFill = rand.nextInt(emptyTiles.length);
    int randomValue = rand.nextInt(100) > 10 ? 2 : 4;
    emptyTiles[indexToFill].tileModel.value = randomValue;
    emptyTiles[indexToFill].updateColors();
    currentScore += randomValue;
    emptyTiles.remove(emptyTiles[indexToFill]);
    currentMaxTileValue =
        randomValue > currentMaxTileValue ? randomValue : currentMaxTileValue;
    if (isFirstStart) {
      indexToFill = rand.nextInt(emptyTiles.length - 1);
      randomValue = rand.nextInt(100) > 10 ? 2 : 4;
      emptyTiles[indexToFill].tileModel.value = randomValue;
      currentScore += randomValue;
      emptyTiles[indexToFill].updateColors();
      currentMaxTileValue =
          randomValue > currentMaxTileValue ? randomValue : currentMaxTileValue;
    }
  }

  void shiftTileList(
      {required List<GameTile> listToShift,
      required MovingDirection movingDirection,
      required int shiftingStartIndex}) {
    for (int i = shiftingStartIndex; i < listToShift.length; i++) {
      if (listToShift[i].isEmpty()) {
        for (int j = i + 1; j < listToShift.length; j++) {
          if (!listToShift[j].isEmpty()) {
            swapTileModels(tile1: listToShift[i], tile2: listToShift[j]);
            gameChanged = true;
            if (i != 0)
              listToShift[i]
                  .moveTile(direction: movingDirection, onCompleted: () {});
            break;
          }
        }
      }
    }
  }

  void printTilesList({required List<GameTile> tileList}) {
    String tilesText = "[";
    for (var i = 0; i < tileList.length; i++) {
      tilesText +=
          "${tileList[i].tileModel.value}${i == tileList.length - 1 ? "" : ","}";
    }
    tilesText += "]";
    print(tilesText);
  }

  Future<void> saveScore() async {
    if (settingsAndScoreModel.highestScore < this.currentScore) {
      settingsAndScoreModel.highestScore = this.currentScore;
      await settingsAndScoreModel.saveSettings();
    }
  }

  void newGame() {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < cols; j++) {
        gameTiles[i][j].tileModel.value = 0;
        gameTiles[i][j].reset();
      }
    currentMaxTileValue = 0;
    currentScore = 0;
    fillRandomTile(isFirstStart: true);
  }
}
