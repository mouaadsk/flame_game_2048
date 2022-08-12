import 'package:game_2048/shared/gameColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuButton extends StatelessWidget {
  final String assetPath, buttonText;
  final VoidCallback onPressed;
  const MenuButton(
      {Key? key,
      required this.assetPath,
      required this.buttonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width;
    return TextButton(
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(width * .7, width * .2)),
          alignment: Alignment.center,
          foregroundColor: MaterialStateProperty.all(appTextColor1),
          backgroundColor: MaterialStateProperty.all(appMainColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * .02),
          )),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: width * .12,
            fontWeight: FontWeight.bold,
          ))),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            color: appTextColor1,
            height: width * .1,
          ),
          SizedBox(width: width * .02),
          Text(buttonText)
        ],
      ),
    );
  }
}
