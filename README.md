# flutter_check_adjust_cloak

A new Flutter project.

## Get started

### Set Proguard

Create `proguard-rules.pro` file into your android->app, add content in this file
```dart
-keep public class com.adjust.sdk.**{ *; }
-keep class com.google.android.gms.common.ConnectionResult {
    int SUCCESS;
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}
-keep public class com.android.installreferrer.**{ *; }
```

If your publishing target is not a Google Play store, please add the following rules to the Proguard file:
```dart
-keep public class com.adjust.sdk.**{ *; }
-keep public class com.android.installreferrer.**{ *; }
```

Quote proguard-rules.pro into your app->`build.gradle`
```dart
buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
```

### Set up session tracking

Default support for session tracking on iOS devices, To set up session tracking for Android devices, you can globally set it on the homepage or set it according to each widget
```dart
import 'package:adjust_sdk/adjust.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<mainscreen> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      default:
        break;
    }
  }
}
```

### Configure firebase data

#### Android 
1.copy `google-services.json` in your project->android->app
2.in your app->`build.gradle`, add `apply plugin: 'com.google.gms.google-services'`
example
```dart
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
```
3.in your project->`build.gradle`->`buildscript`->`dependencies` ,add ` classpath 'com.google.gms:google-services:4.3.15'`
example
```dart
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
```

#### iOS
use xCode open ios project,right click `Runner`,choose `Add files to "Runner"`, and choose your `GoogleService-Info.plist`

### Examples

1.Init
```dart
 FlutterCheckAdjustCloak.instance.initCheck(
cloakPath: path,
normalModeStr: "",
blackModeStr: "",
adjustToken: "",
distinctId: distinctId,
unknownFirebaseKey: "",
referrerConfKey: "",
adjustListener: this
);
```
2.Check type, callback true means buy user ,false means not
```dart
FlutterCheckAdjustCloak.instance.checkType();
```

3.Force buy user,just debug mode effective
```dart
FlutterCheckAdjustCloak.instance.forceBuyUser(true);
```
4.if you want test firebase
```dart
FlutterCheckAdjustCloak.instance.setTestFirebase(true);
```


