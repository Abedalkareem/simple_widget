import 'package:flutter/material.dart';
import 'package:native_widget/native_widget.dart';
import 'package:native_widget_example/game_widget_example.dart';
import 'package:native_widget_example/multiple_types_example.dart';
import 'package:native_widget_example/one_widget_example.dart';
import 'package:native_widget_example/update_widget_screen.dart';
import 'package:native_widget_example/widget_from_screen_example.dart';

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
      final id = event?.queryParameters[
          "id"]; // You can use this id to update the home widget on android.
      // if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateWidgetScreen(
            id: id ?? "--",
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
        primaryColor: Colors.red,
        appBarTheme: const AppBarTheme(
          color: Colors.red,
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
    _nativeWidgetPlugin.widgetClicked.listen((event) async {
      debugPrint(event.toString());
      final id = event?.queryParameters[
          "id"]; // You can use this id to update the home widget on android.
      // if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateWidgetScreen(
            id: id ?? "--",
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MultipleTypesExample()),
                );
              },
              child: const Text("Multiple types example"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OneWidgetExample()),
                );
              },
              child: const Text("One widget example"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WidgetFromScreenExample()),
                );
              },
              child: const Text("Widget from screen example"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameWidgetExample()),
                );
              },
              child: const Text("Game widget example"),
            ),
          ],
        ),
      ),
    );
  }
}
