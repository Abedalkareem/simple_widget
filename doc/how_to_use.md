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
        backgroundPath1,
        foregroundPath1,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        id,
        backgroundPath2,
        foregroundPath2,
      ),
      AppWidgetData(
        date.add(const Duration(hours: 3)).millisecondsSinceEpoch,
        id,
        backgroundPath3,
        foregroundPath3,
      )
    ];
```

The image paths above are relative file paths returned by `saveImageFile()`. You can use `WidgetToImage.dataFromWidget()` to render a widget to image bytes, then save them to a file using `saveImageFile()`.

```dart
  final _simpleWidgetPlugin = SimpleWidget();

  Future<String> imageBackground(String image) async {
    final data = await WidgetToImage.dataFromWidget(
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
    return await _simpleWidgetPlugin.saveImageFile(data!);
  }
```

After you have the list of widget, you can create a time line.

```dart
  Future<void> _updateWidgets() async {
    const timelineID = "1";
    await _simpleWidgetPlugin.updateWidgets(
      [TimeLine(type: "Images", id: timelineID, data: myWidgets)],
    );
    await _simpleWidgetPlugin.refresh();
  }
```

## Select a widget to show

On iOS:
- Add a new widget from the app by tapping on the add button on the top right side of the screen.
- Go back to your device home screen and long press on the screen.
- Tap on the add button on the top left side of the screen.
- Long press on the app home widget and drop it on the home screen.
- Long press on the widget you just added and then select Edit Widget.
- Tap on the Type.
- Select the widget you want to set.

On Android:
- Add a new widget from the app by tapping on the add button on the top right side of the screen.
- Go back to your device home screen and long press on the screen.
- Tap on Widgets.
- Expand the app.
- Long press on the widget you want to add and drop it on the home screen.
- You can resize the widget by long pressing on it and then drag the corners to resize it.
- Tap on the widget to open the app in the selection mode.
- Select the widget you want to set.

## Refresh rate

- For iOS, the refresh rate is 15 minutes.
- For Android, the refresh rate is 30 minutes.

## More examples

To see more examples check the example folder in the plugin repo.