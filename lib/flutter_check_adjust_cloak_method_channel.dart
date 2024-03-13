import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_check_adjust_cloak_platform_interface.dart';

/// An implementation of [FlutterCheckAdjustCloakPlatform] that uses method channels.
class MethodChannelFlutterCheckAdjustCloak extends FlutterCheckAdjustCloakPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_check_adjust_cloak');

  @override
  Future<bool> checkHasSim() async{
    return await methodChannel.invokeMethod("checkHasSim");
  }
}

