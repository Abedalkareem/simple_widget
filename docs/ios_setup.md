To be able to use the plugin on iOS you have to do few steps on the native side.

## Add the Widget targets to your project
- Open the xCode workspace (`Runner.xcworkspace`).
- Click on `File`, `New`, then `Target`.
- Search for `Widget Extension`.
- Click on `Next`.
- Enter the name of the extension, for example `HomeWidget`.
- Click on `Finish`.
- A dialog will appear, click on `Cancel`.
- Now agian, click on `File`, `New`, then `Target`.
- Search for `Intents Extension`.
- Click on `Next`.
- Enter the name of the extension, for example `HomeWidgetIntent`.
- Click on `Finish`.
- A dialog will appear, click on `Cancel`.
- Delete the `HomeWidget.swift` and `HomeWidgetBundle.swift` file.
- From the plugin `example/Runner/WidgetExample` copy the `AppWidget.swift`, `AppWidgetBundle.swift`, `AppWidgetEntryView.swift`, `Provider.swift`, `Settings.swift`, `Storage.swift` and `WidgetExample.intentdefinition` files to the `HomeWidget` folder in your project using xCode.
- Remmber the `Settings.swift` file as we will updated it later in the `Add the App Group` section of this page.
- Select the target membership of the files you just copied to the `HomeWidget` folder to the `HomeWidget` and `HomeWidgetIntent` targets.
- Delete the `IntentHandler.swift` file from the `HomeWidgetIntent` folder.
- Now from the plugin `example/Runner/IntentsExtension` copy the `IntentHandler.swift` file to the `HomeWidgetIntent` folder in your project using xCode.
- Select the target membership of the `IntentHandler.swift` file you just copied to the `HomeWidgetIntent` folder to the `HomeWidgetIntent` target.

## Add the App Group

- Select the Runner project in the Project Navigator.
- Select the Runner target.
- Select the `Signing & Capabilities` tab.
- Click on `+ Capability`.
- Search for `App Groups`.
- Click on `+` button in the `App Groups` section.
- Enter the name of the app group, for example `group.com.example.app`.
- Go back to the `Settings.swift` file in the `HomeWidget` folder and update the `appGroup` variable with the app group name you just created.

## ....

Like that we have finished the native side, now we can use the plugin in our flutter app. To do that please check the `creating_widget.md`.