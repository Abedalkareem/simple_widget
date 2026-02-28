import 'dart:io';

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
                    _ImageFromPath(
                        imagePath: data.background, boxFit: BoxFit.cover),
                    Center(
                        child: _ImageFromPath(
                            imagePath: data.foreground, boxFit: BoxFit.contain)),
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

class _ImageFromPath extends StatefulWidget {
  final String imagePath;
  final BoxFit boxFit;

  const _ImageFromPath({required this.imagePath, required this.boxFit});

  @override
  State<_ImageFromPath> createState() => _ImageFromPathState();
}

class _ImageFromPathState extends State<_ImageFromPath> {
  late Future<File> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = _getImageFile();
  }

  Future<File> _getImageFile() async {
    final basePath = await SimpleWidget().getImageBasePath();
    return File('$basePath/${widget.imagePath}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _fileFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        return Image.file(
          snapshot.data!,
          fit: widget.boxFit,
          width: double.infinity,
        );
      },
    );
  }
}
