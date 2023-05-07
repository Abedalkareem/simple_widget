import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_widget_example/off_topic/widget_viewer_item.dart';
import 'package:timelined_native_widget/native_widget.dart';

class WidgetsScreen extends StatefulWidget {
  final String id;
  const WidgetsScreen({super.key, required this.id});

  @override
  State<WidgetsScreen> createState() => _WidgetsScreenState();
}

class _WidgetsScreenState extends State<WidgetsScreen> {
  final _nativeWidget = NativeWidget();
  List<TimeLine> timelines = [];
  bool done = false;

  @override
  void initState() {
    super.initState();

    _getTimelines();
  }

  void _getTimelines() async {
    await _nativeWidget.setAppScheme("widgets");
    final timelines = await _nativeWidget.getTimelinesData();
    setState(() {
      this.timelines = timelines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id.isEmpty
            ? 'Widgets'
            : 'Update widget with id ${widget.id}'),
      ),
      body: timelines.isEmpty
          ? Center(
              child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "You don't have any widgets yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: "Michelia",
                    ),
                  ),
                ],
              ),
            ))
          : done
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Widget is set! you can now check your home screen",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: "Michelia",
                        ),
                      ),
                    ],
                  ),
                ))
              : ListView(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  children: timelines.reversed
                      .map(
                        (timeline) => SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.id.isEmpty) {
                                return;
                              }
                              timelines
                                  .where((element) => element.id == timeline.id)
                                  .forEach((element) {
                                for (var element in element.data) {
                                  element.id = "";
                                }
                                element.id = "";
                              });
                              final item = timelines
                                  .where((element) =>
                                      element.type == timeline.type)
                                  .toList()
                                  .first;
                              item.id = widget.id;
                              for (var element in item.data) {
                                element.id = widget.id;
                              }
                              _nativeWidget.updateWidgets(timelines);
                              _nativeWidget.refresh();
                              setState(() {
                                done = true;
                              });
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.pop(context);
                              });
                            },
                            child: WidgetViewerItem(
                              data: timeline.data.first,
                              type: timeline.type,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
    );
  }
}
