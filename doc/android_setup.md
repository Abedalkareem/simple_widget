To be able to use the plugin on Android you have to do few steps on the native side.

## Add the native code

- Open the android folder in your project using Android Studio.
- From the plugin `example/android/app/src/main/kotlin/com/example/simple_widget` copy the `AppSharedPreferences.kt`, `AppWidgetData.kt`, `AppWidgetProvider.kt`, `Settings.kt`, folder to your android project project.
- From the plugin `example/android/app/src/main/res/` copy the `xml`, `xml-v17`, `layout` folders to your android project project.
- Add `implementation 'com.google.code.gson:gson:2.9.1'` to the `dependencies` section in the `android/app/build.gradle` file.
- Add to your minufest file the following:
```xml
       <receiver android:name="SimpleWidgetProvider"
           android:exported="false">
           <intent-filter>
               <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
           </intent-filter>
           <meta-data android:name="android.appwidget.provider"
               android:resource="@xml/simple_widget" />
       </receiver>
```