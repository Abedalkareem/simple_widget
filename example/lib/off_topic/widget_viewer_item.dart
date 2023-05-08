import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_widget/simple_widget.dart';

class WidgetViewerItem extends StatelessWidget {
  final AppWidgetData data;
  final String? type;
  final double width;
  final double height;
  const WidgetViewerItem({
    required this.data,
    this.type,
    this.width = double.infinity,
    this.height = 150,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: height,
                width: width,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    imageFromBase64String(data.background, BoxFit.cover),
                    Center(
                        child: imageFromBase64String(
                            data.foreground, BoxFit.contain)),
                  ],
                ),
              ),
            ),
          ),
          if (type != null)
            Text(type!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "Michelia",
                ))
        ],
      ),
    );
  }
}

Image imageFromBase64String(String base64String, BoxFit boxFit) {
  return Image.memory(
    base64Decode(base64String),
    fit: boxFit,
    width: double.infinity,
  );
}
