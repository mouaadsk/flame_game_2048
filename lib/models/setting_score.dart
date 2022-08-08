import 'package:shared_preferences/shared_preferences.dart';

class SettingsAndScoreModel {
  late int highestScore, soundVolume;
  late bool soundActivated;
  int currentScore = 0;
  late final SharedPreferences prefs;

  SettingsAndScoreModel() {
    initialize();
  }

  Future<bool> initialize() async {
    try {
      prefs = await SharedPreferences.getInstance();
      highestScore = prefs.getInt("highestScore") ?? 0;
      soundActivated = prefs.getBool("soundActivated") ?? true;
      soundVolume = prefs.getInt("soundVolume") ?? 70;
      return true;
    } catch (e) {
      print("error in initiliazing the SettingAndScoreModel : ${e.toString()}");
      return false;
    }
  }

  void setCurrentScore(int score) => currentScore = score;
  void resetCurrentScore() => currentScore = 0;
  void setHightestScore(int score) => highestScore = score;
  void setSoundVolume(int volume) => soundVolume = volume;
  void toggleSoudnActivation() => soundActivated = !soundActivated;
  Future<bool> saveSettings() async {
    try {
      await prefs.setBool("soundActivated", soundActivated);
      await prefs.setInt("soundVolume", soundVolume);
      await prefs.setInt("highestScore", highestScore);
      return true;
    } catch (e) {
      print(
          "Error in saving the settings in the settingAndScoreModel : ${e.toString()}");
      return false;
    }
  }
}
