import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:native_widget/models/app_widget_data.dart';
import 'package:native_widget/native_widget.dart';
import 'package:native_widget/util/widget_to_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _nativeWidgetPlugin = NativeWidget();

  @override
  void initState() {
    super.initState();

    _setup();
  }

  void _setup() async {
    await _nativeWidgetPlugin.setGroupID("group.abedalkareem.widgets");
    await _nativeWidgetPlugin.setAppScheme("widgets");
    _listenForWidgetClicked();
  }

  void _listenForWidgetClicked() {
    _nativeWidgetPlugin.widgetClicked.listen((event) async {
      debugPrint(event.toString());
      final id = event?.queryParameters["id"];
      debugPrint(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
        appBarTheme: const AppBarTheme(
          color: Colors.red,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native widget example'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                _updateWidgets();
              },
              child: const Text("Update Widgets"),
            ),
            ElevatedButton(
              onPressed: () async {
                _refreshWidgets();
              },
              child: const Text("Refresh Widgets"),
            ),
          ],
        )),
      ),
    );
  }

  void _refreshWidgets() async {
    await _nativeWidgetPlugin.refresh();
  }

  Future<void> _updateWidgets() async {
    final background1 = await background("assets/images/cat.jpg");
    final foreground1 = await forground("Native Widget");
    final background2 = await background("assets/images/city.png");
    final foreground2 = await forground("Hello Flutter");
    final background3 = await background("assets/images/green.png");
    final foreground3 = await forground("Hello World");
    await _nativeWidgetPlugin.updateWidgets(
      [
        AppWidgetData("Hello", background1, foreground1),
        AppWidgetData("Flutter", background2, foreground2),
        AppWidgetData("Widget", background3, foreground3),
      ],
    );
    await _nativeWidgetPlugin.refresh();
  }

  Future<String> background(String image) async {
    final background = await WidgetToImage.dataFromWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 500,
          height: 250,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              )
            ],
          ),
        ),
      ),
    );
    String base64Image = base64Encode(background!);

    return base64Image;
  }

  Future<String> forground(String text) async {
    final background = await WidgetToImage.dataFromWidget(
      SizedBox(
        width: 500,
        height: 250,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: "Michelia",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    String base64Image = base64Encode(background!);
    return base64Image;
  }
}