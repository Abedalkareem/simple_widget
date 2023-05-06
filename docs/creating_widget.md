## Copy the native code

First step is to copy the native code, don't worry it's not that much and you don't need to do any work. 

Check the android setup part in the docs folder to know how to copy the native code. And you should do the same for iOS.

## Create the widget

- First, you have to create a list of widgets that you want to show in the widget, for example, below is a list of 3 widgets, first one will be shown once the user select the widget, then after 2 hours another widget will be shown, and one hour later after that time another widget will be shown.

```dart
final date = DateTime.now();

final myWidgets = [
      AppWidgetData(
        date
            .add(const Duration(hours: 0))
            .millisecondsSinceEpoch, //  at least one widget should be created with the current time.
        id,
        background1Base64,
        foreground1Base64,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        id,
        background2Base64,
        foreground2Base64,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 3)).millisecondsSinceEpoch,
        id,
        background3Base64,
        foreground3Base64,
      )
    ];
```

The base64 strings above are the images that will be shown in the widget, you can use `WidgetToImage.dataFromWidget()` to get a base64 string from a widget.

```dart
  Future<String> imageBackground(String image) async {
    final background = await WidgetToImage.dataFromWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 500,
          height: 250,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      size: const Size(500, 250),
      wait: const Duration(seconds: 1),
    );
    String base64Image = base64Encode(background!);

    return base64Image;
  }
```

After you have the list of widget, you can create a time line.

```dart
  Future<void> _updateWidgets() async {
    const timelineID = "1";
    await _nativeWidgetPlugin.updateWidgets(
      [TimeLine(type: "Images", id: timelineID, data: myWidgets)],
    );
    await _nativeWidgetPlugin.refresh();
  }
```

## More examples

To see more examples check the example folder in the plugin repo.