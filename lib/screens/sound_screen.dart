import 'package:axie_scholarship/components/gameButton.dart';
import 'package:axie_scholarship/models/setting_score.dart';
import 'package:axie_scholarship/screens/main_menu_screen.dart';
import 'package:axie_scholarship/shared/gameColors.dart';
import 'package:axie_scholarship/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({Key? key}) : super(key: key);

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  final SettingsAndScoreModel controller = Get.find<SettingsAndScoreModel>();
  int currentVolume = 0;
  late bool soundActivated;
  @override
  void initState() {
    super.initState();
    setState(() {
      currentVolume = controller.soundVolume;
      soundActivated = controller.soundActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        await Get.offNamed("/home");
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appTextColor1,
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sound Volume",
                  style: TextStyle(
                      color: appMainColor,
                      fontSize: width * .09,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: width * .06,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      valueIndicatorColor: appMainColor,
                      valueIndicatorTextStyle: TextStyle(
                          color: appTextColor1, fontWeight: FontWeight.bold)),
                  child: Slider(
                      divisions: 100,
                      label: "$currentVolume",
                      thumbColor: appMainColor,
                      activeColor: appMainColor,
                      inactiveColor: darkerMainColor,
                      min: 0,
                      max: 100,
                      value: currentVolume.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          currentVolume = value.toInt();
                        });
                        print(currentVolume.toInt());
                      }),
                ),
                SizedBox(
                  height: width * .1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sound Enabled",
                      style: TextStyle(
                          color: appMainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: width * .09),
                    ),
                    Transform.scale(
                      scale: 1.6,
                      child: CheckboxTheme(
                        data: CheckboxThemeData(
                            side: AlwaysActiveBorderSide(
                                borderSide: BorderSide(
                                    color: appMainColor, width: width * .005))),
                        child: Checkbox(
                            tristate: false,
                            splashRadius: 0,
                            checkColor: appMainColor,
                            fillColor:
                                MaterialStateProperty.all<Color>(appTextColor1),
                            value: soundActivated,
                            onChanged: (value) {
                              setState(() {
                                soundActivated = value ?? true;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * .15,
                ),
                MenuButton(
                    assetPath: "assets/images/svg/save.svg",
                    buttonText: "Save",
                    onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlwaysActiveBorderSide extends MaterialStateBorderSide {
  final BorderSide borderSide;

  const AlwaysActiveBorderSide({required this.borderSide});

  @override
  BorderSide? resolve(_) => borderSide;
}
