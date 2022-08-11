import 'package:axie_scholarship/models/setting_score.dart';
import 'package:get/get.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SettingsAndScoreModel>(SettingsAndScoreModel(), permanent: true);
  }
}
