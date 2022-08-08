import 'package:axie_scholarship/models/setting_score.dart';
import 'package:axie_scholarship/screens/game_play_screen.dart';
import 'package:axie_scholarship/shared/gameColors.dart';
import 'package:axie_scholarship/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMenuScreen extends StatelessWidget {
  SettingsAndScoreModel settingsAndScoreModel = SettingsAndScoreModel();
  MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff3D3A33),
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: width * .1, bottom: width * .2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Classic 2048",
                  style: TextStyle(
                    color: appMainColor,
                    fontSize: width * .12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    MenuButton(
                        assetPath: "assets/images/svg/play-game.svg",
                        buttonText: "Play",
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => GamePlayScreen(
                                        settingsAndScoreModel:
                                            settingsAndScoreModel,
                                      )));
                        }),
                    SizedBox(height: width * .05),
                    MenuButton(
                        assetPath: "assets/images/svg/sound-adjust.svg",
                        buttonText: "Sound",
                        onPressed: () {}),
                  ],
                ),
                Text(
                  "Highest Score : ${settingsAndScoreModel.highestScore}",
                  style: TextStyle(
                      color: const Color(0xffF5E8DF),
                      fontSize: width * .08,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
