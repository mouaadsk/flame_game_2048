import 'package:audioplayers/audioplayers.dart';
import 'package:game_2048/models/setting_score.dart';
import 'package:game_2048/shared/app_audios.dart';
import 'package:game_2048/shared/gameColors.dart';
import 'package:game_2048/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({Key? key}) : super(key: key);
  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  final SettingsAndScoreModel settingsModel = Get.find<SettingsAndScoreModel>();
  final player = AudioPlayer();
  int currentVolume = 0;
  late bool soundActivated;
  @override
  void initState() {
    super.initState();
    setState(() {
      currentVolume = settingsModel.soundVolume;
      soundActivated = settingsModel.soundActivated;
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
                      onChangeEnd: (value) async {
                        if (settingsModel.soundActivated)
                          await player.play(AssetSource("audio/4.mp3"),
                              volume: (currentVolume / 100).toDouble());
                      },
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
                            onChanged: (value) async {
                              setState(() {
                                soundActivated = value ?? true;
                              });
                              if (soundActivated == true) if (settingsModel
                                  .soundActivated)
                                await player.play(AssetSource("audio/8.mp3"),
                                    volume: (currentVolume / 100).toDouble());
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
                    onPressed: () async {
                      if (settingsModel.soundActivated)
                        await player.play(
                            AssetSource("audio/${buttonClickSound}"),
                            volume: (currentVolume / 100).toDouble());
                      settingsModel.setSoundVolume(currentVolume);
                      settingsModel.soundActivated = soundActivated;
                      await settingsModel.saveSettings();
                      await Get.offNamed("/home");
                    }),
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
