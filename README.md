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
      case AppLifecycleState.suspending:
        break;
    }
  }
}
```

### Examples

1.Init
```dart
FlutterCheckAdjustCloak.instance.setConfigAndInit(
    cloakPath: cloakPath,
    normalModeStr: normalModeStr,
    blackModeStr: blackModeStr,
    adjustToken: adjustToken,
    distinctId: distinctId)
;
```
2.Check type, callback true means buy user ,false means not
```dart
FlutterCheckAdjustCloak.instance.checkType();
```

3.Force buy user,just debug mode effective
```dart
FlutterCheckAdjustCloak.instance.forceBuyUser(true);
```


