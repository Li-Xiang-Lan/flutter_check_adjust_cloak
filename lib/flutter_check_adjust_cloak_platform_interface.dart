import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_check_adjust_cloak_method_channel.dart';

abstract class FlutterCheckAdjustCloakPlatform extends PlatformInterface {
  /// Constructs a FlutterCheckAdjustCloakPlatform.
  FlutterCheckAdjustCloakPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCheckAdjustCloakPlatform _instance = MethodChannelFlutterCheckAdjustCloak();

  /// The default instance of [FlutterCheckAdjustCloakPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCheckAdjustCloak].
  static FlutterCheckAdjustCloakPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCheckAdjustCloakPlatform] when
  /// they register themselves.
  static set instance(FlutterCheckAdjustCloakPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
