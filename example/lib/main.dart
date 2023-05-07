import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_widget_example/widgets_screen.dart';
import 'package:timelined_native_widget/native_widget.dart';

import 'off_topic/app_button.dart';
import 'game_widget_example.dart';
import 'multiple_types_example.dart';
import 'one_widget_example.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
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
      final id = event?.queryParameters[
          "id"]; // You can use this id to update the home widget on android.
      // if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WidgetsScreen(
            id: id ?? "",
          ),
        ),
      );
      // }
      debugPrint(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          secondary: Colors.black,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Michelia",
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    if (Platform.isIOS) {
      return;
    }
    _nativeWidgetPlugin.widgetClicked.listen((event) async {
      debugPrint(event.toString());
      final id = event?.queryParameters[
          "id"]; // You can use this id to update the home widget on android.
      // if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WidgetsScreen(
            id: id ?? "",
          ),
        ),
      );
      // }
      debugPrint(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native widget example'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MultipleTypesExample()),
                  );
                },
                text: "Multiple types example",
              ),
              AppButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OneWidgetExample()),
                  );
                },
                text: "One widget example",
              ),
              AppButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GameWidgetExample()),
                  );
                },
                text: "Game widget example",
              ),
              AppButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WidgetsScreen(
                              id: '',
                            )),
                  );
                },
                text: "View widgets",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
