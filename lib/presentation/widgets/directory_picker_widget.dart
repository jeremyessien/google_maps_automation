import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DirectoryPickerWidget extends StatelessWidget {
  final VoidCallback onSelectDirectory;

  const DirectoryPickerWidget({super.key, required this.onSelectDirectory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectDirectory,
      child: Container(
        width: 250,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Platform.isAndroid
                ? Icon(Icons.folder_copy)
                : Icon(CupertinoIcons.folder),
            SizedBox(width: 8),
            const Text('Select Flutter Project'),
          ],
        ),
      ),
    );
  }
}
