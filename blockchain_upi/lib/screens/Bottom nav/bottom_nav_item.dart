import 'package:blockchain_upi/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavItem extends StatelessWidget {
  final IconData? iconData;
  final VoidCallback? onTap;
  final bool? isSelected;
  final String name;
  const BottomNavItem(
      {super.key,
      @required this.iconData,
      this.onTap,
      this.isSelected = false,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // width: MediaQuery.of(context).size.width * 0.25,
      // padding: const EdgeInsets.only(top: 5),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashColor: bg1,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Icon(
              iconData,
              color: isSelected! ? Color(0xFF5B6BE4) : black1,
              size: 25,
            ),
            Text(
              name,
              style: TextStyle(
                color: isSelected! ? Color(0xFF5B6BE4) : black1,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        onPressed: onTap!,
      ),
    );
  }
}
