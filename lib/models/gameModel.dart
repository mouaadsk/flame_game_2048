import 'dart:math';
import 'package:axie_scholarship/components/gameTile.dart';
import 'package:axie_scholarship/enums/movingDirection.dart';
import 'package:axie_scholarship/game.dart';
import 'package:axie_scholarship/models/tileModel.dart';
import 'package:flame/extensions.dart';

class GameModel {
  int cols, rows;
  List<List<GameTile>> gameTiles = [];
  Game2048 gameRef;
  bool gameChanged = false;
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
  }

  void merge({required MovingDirection mergingDirection}) {
    print("Swiping : $mergingDirection");
    List<GameTile> columnList = [];
    switch (mergingDirection) {
      case MovingDirection.Right:
        for (var i = 0; i < rows; i++) {
          mergeTileList(
              tileList: this.gameTiles[i].reversed.toList(),
              mergingDirection: MovingDirection.Right);
        }
        break;
      case MovingDirection.Left:
        for (var i = 0; i < rows; i++) {
          mergeTileList(
              tileList: this.gameTiles[i],
              mergingDirection: MovingDirection.Left);
        }
        break;
      case MovingDirection.Down:
        for (var i = 0; i < cols; i++) {
          for (var j = 0; j < rows; j++) {
            columnList.add(gameTiles[j][i]);
          }
          mergeTileList(
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
          mergeTileList(
              tileList: columnList, mergingDirection: MovingDirection.Up);
          columnList = [];
        }
        break;
    }
    if (gameChanged) {
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        fillRandomTile();
        gameChanged = false;
        //printTilesValues();
      });
    }
  }

  Future<void> addTileToGame() async {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        await gameRef.add(gameTiles[i][j]);
      }
    }
  }

  void mergeTileList(
      {required List<GameTile> tileList, required mergingDirection}) async {
    await reorderTileList(
        tileList: tileList, movingDirection: mergingDirection);
    for (int i = 0; i < tileList.length - 1; i++) {
      if (!tileList[i].isEmpty()) {
        tileList[i].mergeWithTile(
            movingDirection: mergingDirection,
            gameTile: tileList[i + 1],
            onMerging: () {
              gameChanged = true;
            });
      }
    }
    await reorderTileList(
        tileList: tileList, movingDirection: mergingDirection);
    await reorderTileList(
        tileList: tileList, movingDirection: mergingDirection);
    for (var i = 0; i < tileList.length - 1; i++) tileList[i].reset();
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
    print("Before reorder");
    printTilesList(tileList: tileList);
    for (int i = 0; i < tileList.length; i++) {
      if (tileList[i].isEmpty()) {
        for (int j = i + 1; j < tileList.length; j++) {
          if (!tileList[j].isEmpty()) {
            if (i != 0)
              await tileList[i].moveTile(
                  direction: movingDirection,
                  onCompleted: () {
                    print("Moving the tile from the reorder function");
                  });
            gameChanged = true;
            swapTileModels(tile1: tileList[i], tile2: tileList[j]);
            break;
          }
        }
      }
    }
    print("After reorder");
    printTilesList(tileList: tileList);
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
    List<GameTile> emptyTiles = [];
    for (var i = 0; i < rows; i++) {
      emptyTiles.addAll(gameTiles[i].where((tile) => tile.isEmpty()));
    }
    int indexToFill = Random().nextInt(emptyTiles.length - 1);
    emptyTiles[indexToFill].tileModel.value =
        Random().nextInt(100) > 10 ? 2 : 4;
    emptyTiles[indexToFill].updateColors();
    emptyTiles.remove(emptyTiles[indexToFill]);
    if (isFirstStart) {
      indexToFill = Random().nextInt(emptyTiles.length - 1);
      emptyTiles[indexToFill].tileModel.value =
          Random().nextInt(100) > 10 ? 2 : 4;
      emptyTiles[indexToFill].updateColors();
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
}
