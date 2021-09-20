class TileModel {
  int value;
  bool merged = false;
  TileModel({required this.value});

  bool merge({required TileModel tileModel}) {
    if (!merged && tileModel.value == this.value && !tileModel.merged) {
      value += tileModel.value;
      tileModel.value = 0;
      tileModel.merged = false;
      merged = true;
      return true;
    }
    return false;
  }

  void reset() {
    merged = false;
  }

  static void swapTiles(
      {required TileModel tileModel1, required TileModel tileModel2}) {
    TileModel tempTileModel = tileModel1;
    tileModel1 = tileModel2;
    tileModel2 = tempTileModel;
  }

  bool isEmpty() => value == 0;
}
