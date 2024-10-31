import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/adjust/request_adjust.dart';
import 'package:flutter_check_adjust_cloak/cloak/request_cloak.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak_platform_interface.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/referrer/request_referrer.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class FlutterCheckAdjustCloak {
  static final FlutterCheckAdjustCloak _instance = FlutterCheckAdjustCloak();
  static FlutterCheckAdjustCloak get instance => _instance;

  bool _forceBuyUser=false,_hasSim=false,_isB=false;
  String _userTypeFirebaseStr="";
  String _adjustConfKey="1";
  final List<String> _referrerConfList=[];
  late FirebaseRemoteConfig _remoteConfig;
  CheckListener? _checkListener;
  RequestCloak? _requestCloak;

  ///initCheck
  initCheck({
    required String cloakPath,
    required String normalModeStr,
    required String blackModeStr,
    required String adjustToken,
    required bool adjustSandbox,
    required String distinctId,
    required String unknownFirebaseKey,
    required String referrerConfKey,
    required String adjustConfKey,
    required CheckListener checkListener,
    String? adjustConfDefaultStr,
  })async{
    _checkListener=checkListener;
    _adjustConfKey=adjustConfDefaultStr??"1";
    _requestCloak=RequestCloak(cloakPath: cloakPath, normalModeStr: normalModeStr, blackModeStr: blackModeStr,checkListener: _checkListener);
    RequestAdjust(adjustToken: adjustToken, adjustSandbox: adjustSandbox,distinctId: distinctId,checkListener: _checkListener);
    RequestReferrer();

    var initFirebaseResult = await _initFirebase();
    if(initFirebaseResult){
      if(Platform.isAndroid){
        _hasSim=await checkHasSim();
        _userTypeFirebaseStr = await getFirebaseStrValue(unknownFirebaseKey);
        try{
          var referrerConf = await getFirebaseStrValue(referrerConfKey);
          _referrerConfList.clear();
          _referrerConfList.addAll(referrerConf.split("|"));
        }catch(e){}
      }else{
        _adjustConfKey = await getFirebaseStrValue(adjustConfKey);
      }
    }
  }

  Future<bool> _initFirebase()async{
    try{
      await Firebase.initializeApp();
      _remoteConfig=FirebaseRemoteConfig.instance;
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await _remoteConfig.fetchAndActivate();
      _checkListener?.initFirebaseSuccess();
      return true;
    }catch(e){
      return false;
    }
  }


  ///getFirebaseStrValue
  Future<String> getFirebaseStrValue(String key)async{
    try{
      if(key.isEmpty){
        return "";
      }
      return _remoteConfig.getString(key);
    }catch(e){
      return "";
    }
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
      _isB=true;
      return _isB;
    }
    if(Platform.isIOS){
      if(localCloakIsNormalUser()!=true){
        printLogByDebug("check type result--->cloak isBlack");
        _isB=false;
        return _isB;
      }
      if(_adjustConfKey=="1"&&localAdjustIsBuyUser()!=true){
        printLogByDebug("check type result--->adjust not buy user");
        _isB=false;
        return _isB;
      }
    }else{
      // if(!_hasSim){
      //   printLogByDebug("check type result--->no sim");
      //   _isB=false;
      //   return _isB;
      // }
      if(localCloakIsNormalUser()!=true){
        printLogByDebug("check type result--->cloak isBlack");
        _isB=false;
        return _isB;
      }
      if(localAdjustIsBuyUser()!=true){
        printLogByDebug("check type result--->adjust is false");
        _isB=false;
        return _isB;
      }

      if(getLocalReferrerStr().isEmpty&&null==localAdjustIsBuyUser()){
        _isB=_checkUnknownUser();
        return _isB;
      }else{
        var isBuyUser = checkReferrerBuyUser()||(localAdjustIsBuyUser()??false);
        if(!isBuyUser){
          if(!checkReferrerBuyUser()&&!(localAdjustIsBuyUser()??false)){
            printLogByDebug("check type result--->referrer and adjust is false");
            _isB=false;
            return _isB;
          }else{
            _isB=_checkUnknownUser();
            return _isB;
          }
        }
      }
    }
    printLogByDebug("check type result--->is b");
    LocalStorage.write(LocalStorageKey.localUserType, true);
    _isB=true;
    return _isB;
  }

  bool getUserType(){
    if(_forceBuyUser){
      return true;
    }
    var isB = LocalStorage.read<bool>(LocalStorageKey.localUserType)??false;
    if(isB){
      _isB=true;
      return _isB;
    }
    return _isB;
  }

  bool _checkUnknownUser(){
    var b=_userTypeFirebaseStr=="B";
    printLogByDebug("check type result--->firebase config is $_userTypeFirebaseStr");
    if(b){
      LocalStorage.write(LocalStorageKey.localUserType, true);
    }
    return b;
  }

  ///Just debug mode effective
  forceBuyUser(bool force){
    if(kDebugMode){
      _forceBuyUser=force;
    }
  }

  ///true=normal user
  ///false=black user
  ///null=no data
  bool? localCloakIsNormalUser()=>LocalStorage.read<bool>(LocalStorageKey.localCloakIsNormalUserKey);

  ///true=buy user
  ///null=no data
  bool? localAdjustIsBuyUser()=>LocalStorage.read<bool>(LocalStorageKey.localAdjustIsBuyUserKey);

  ///checkHasSim Just Android effective
  Future<bool> checkHasSim()async{
    return FlutterCheckAdjustCloakPlatform.instance.checkHasSim();
  }

  bool checkReferrerBuyUser(){
    var referrerStr = getLocalReferrerStr();
    if(_referrerConfList.isEmpty){
      return referrerStr.contains("adjust");
    }
    return _referrerConfList.indexWhere((element) => referrerStr.contains(element))>=0;
  }

  String getLocalReferrerStr()=>LocalStorage.read<String>(LocalStorageKey.localReferrerKey)??"";

  adjustPoint(String key){
    Adjust.trackEvent(AdjustEvent(key));
  }

  // requestCloakAgain(){
  //   _requestCloak?.requestAgain();
  // }
}
