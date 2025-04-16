import 'dart:io';

import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    this.title,
    this.androidIcon,
    this.iosIcon,
    this.width,
  });

  final Function()? onTap;
  final String? title;
  final IconData? androidIcon;
  final IconData? iosIcon;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 200,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (androidIcon != null )Platform.isAndroid ? Icon(androidIcon) : Icon(iosIcon),
            androidIcon != null || iosIcon != null ?  SizedBox(width: 8) : SizedBox.shrink(),
            Text(title ?? ''),
          ],
        ),
      ),
    );
  }
}
