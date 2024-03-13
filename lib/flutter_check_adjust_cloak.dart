import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/adjust/adjust_listener.dart';
import 'package:flutter_check_adjust_cloak/adjust/request_adjust.dart';
import 'package:flutter_check_adjust_cloak/cloak/request_cloak.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak_platform_interface.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class FlutterCheckAdjustCloak {
  static final FlutterCheckAdjustCloak _instance = FlutterCheckAdjustCloak();
  static FlutterCheckAdjustCloak get instance => _instance;

  bool _forceBuyUser=false,_testFirebase=false;
  bool _hasSim=false;
  String _referrerStr="";
  int _referrerRequestNum=0;
  String _userTypeFirebaseStr="";
  final List<String> _referrerConfList=[];
  late FirebaseRemoteConfig _remoteConfig;

  ///initCheck
  initCheck({
    required String cloakPath,
    required String normalModeStr,
    required String blackModeStr,
    required String adjustToken,
    required String distinctId,
    required String unknownFirebaseKey,
    required String referrerConfKey,
    required AdjustListener adjustListener
  })async{
    await _initFirebase();
    if(null==localCloakIsNormalUser()){
      var requestCloak=RequestCloak(cloakPath: cloakPath, normalModeStr: normalModeStr, blackModeStr: blackModeStr);
      requestCloak.request();
    }

    var requestAdjust=RequestAdjust(adjustToken: adjustToken, distinctId: distinctId);
    requestAdjust.setAdjustListener(adjustListener);
    requestAdjust.request();

    _initReferrer();
    if(Platform.isAndroid){
      _hasSim=await checkHasSim();
      _userTypeFirebaseStr = await getFirebaseStrValue(unknownFirebaseKey);
      try{
        var referrerConf = await getFirebaseStrValue(referrerConfKey);
        _referrerConfList.clear();
        _referrerConfList.addAll(referrerConf.split("|"));
      }catch(e){}
    }
  }

  ///initReferrer Just Android effective
  _initReferrer()async{
    if(Platform.isIOS||_referrerRequestNum>=15){
      return;
    }
    var referrer = LocalStorage.read<String>(LocalStorageKey.localReferrerKey)??"";
    if(referrer.isNotEmpty){
      _referrerStr=referrer;
      return;
    }
    try{
      var referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      _referrerStr=referrerDetails.installReferrer??"";
    }catch(e){
      _referrerRequestNum++;
      _initReferrer();
    }
  }

  _initFirebase()async{
    if(kDebugMode&&!_testFirebase){
      return;
    }
    await Firebase.initializeApp();
    _remoteConfig=FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
  }


  ///getFirebaseStrValue
  Future<String> getFirebaseStrValue(String key)async{
    if(kDebugMode&&!_testFirebase){
      return "";
    }
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString(key);
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
    if(Platform.isIOS){
      if(!(localCloakIsNormalUser()??false)){
        printLogByDebug("check type result--->cloak isBlack");
        return false;
      }
      if(!(localAdjustIsBuyUser()??false)){
        printLogByDebug("check type result--->adjust not buy user");
        return false;
      }
    }else{
      if(!_hasSim){
        printLogByDebug("check type result--->no sim");
        return false;
      }
      if(!(localCloakIsNormalUser()??false)){
        printLogByDebug("check type result--->cloak isBlack");
        return false;
      }
      if(_referrerStr.isEmpty&&null==localAdjustIsBuyUser()){
        return _checkUnknownUser();
      }else{
        if(!checkIsBuyUser()){
          if(!checkReferrerBuyUser()&&!(localAdjustIsBuyUser()??false)){
            printLogByDebug("check type result--->referrer and adjust is false");
            return false;
          }else{
            return _checkUnknownUser();
          }
        }
      }
    }
    printLogByDebug("check type result--->is b");
    LocalStorage.write(LocalStorageKey.localUserType, true);
    return true;
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

  ///Set test firebase,Please configure the required data for firebase first
  setTestFirebase(bool test){
    _testFirebase=test;
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
    if(_referrerConfList.isEmpty){
      return _referrerStr.contains("adjust");
    }
    return _referrerConfList.indexWhere((element) => _referrerStr.contains(element))>=0;
  }

  bool checkIsBuyUser()=>checkReferrerBuyUser()||(localAdjustIsBuyUser()??false);

  adjustPoint(String key){
    Adjust.trackEvent(AdjustEvent(key));
  }
}
