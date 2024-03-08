import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/adjust/adjust_listener.dart';
import 'package:flutter_check_adjust_cloak/adjust/request_adjust.dart';
import 'package:flutter_check_adjust_cloak/cloak/request_cloak.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class FlutterCheckAdjustCloak {
  static final FlutterCheckAdjustCloak _instance = FlutterCheckAdjustCloak();
  static FlutterCheckAdjustCloak get instance => _instance;

  RequestCloak? _requestCloak;
  RequestAdjust? _requestAdjust;
  bool _forceBuyUser=false;

  ///initCloak
  initCloak({
    required String cloakPath,
    required String normalModeStr,
    required String blackModeStr
  })async{
    _requestCloak=RequestCloak(cloakPath: cloakPath, normalModeStr: normalModeStr, blackModeStr: blackModeStr);
    _requestCloak?.request();
  }

  ///initAdjust
  initAdjust({
    required String adjustToken,
    required String distinctId,
  }){
    _requestAdjust=RequestAdjust(adjustToken: adjustToken, distinctId: distinctId);
    _requestAdjust?.request();
  }

  ///check type
  ///true b
  ///false a
  bool checkType(){
    if(_forceBuyUser){
      printLogByDebug("check type result--->forceBuyUser");
      return true;
    }
    var isB = LocalStorage.read<bool>(LocalStorageKey.localUserType)??false;
    if(isB){
      printLogByDebug("check type result--->local storage is true");
      return true;
    }
    if(!(localCloakIsNormalUser()??false)){
      printLogByDebug("check type result--->cloak isBlack");
      return false;
    }
    if(!(localAdjustIsBuyUser()??false)){
      printLogByDebug("check type result--->adjust not buy user");
      return false;
    }
    printLogByDebug("check type result--->is b");
    LocalStorage.write(LocalStorageKey.localUserType, true);
    return true;
  }

  ///just debug mode effective
  forceBuyUser(bool force){
    if(kDebugMode){
      _forceBuyUser=force;
    }
  }

  setAdjustListener(AdjustListener adjustListener){
    _requestAdjust?.setAdjustListener(adjustListener);
  }
}
