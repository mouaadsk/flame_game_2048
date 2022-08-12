import 'package:game_2048/models/setting_score.dart';
import 'package:get/get.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SettingsAndScoreModel>(SettingsAndScoreModel(), permanent: true);
  }
}
