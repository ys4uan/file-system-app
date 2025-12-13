import 'package:flutter/material.dart';

class PictureViewer extends StatelessWidget {
  final List<String> pictureList;

  const PictureViewer({super.key, required this.pictureList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pictureList.length,
      itemBuilder: (context, idx) {
        return Image.network(pictureList[idx]);
      },
    );
  }
}

