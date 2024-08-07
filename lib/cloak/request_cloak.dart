import 'dart:async';
import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class RequestCloak{
  String cloakPath;
  String normalModeStr;
  String blackModeStr;
  CheckListener? checkListener;
  // var _requestNum=0;

  RequestCloak({
    required this.cloakPath,
    required this.normalModeStr,
    required this.blackModeStr,
    required this.checkListener,
  }){
    _request();
  }

  _request()async{
    // if(_requestNum>=20){
    //   return;
    // }
    checkListener?.firstRequestCloak();
    printLogByDebug("request cloak result--> $cloakPath");
    var result = await DioManager.instance.requestGet(url: cloakPath);
    printLogByDebug("request cloak result--> ${result.result}");
    if(result.success&&(result.result==normalModeStr||result.result==blackModeStr)){
      LocalStorage.write(LocalStorageKey.localCloakIsNormalUserKey, result.result==normalModeStr);
      checkListener?.firstRequestCloakSuccess();
    }else{
      Future.delayed(const Duration(milliseconds: 2000),(){
        // _requestNum++;
        _request();
      });
    }
  }

  // requestAgain(){
  //   if(_requestNum>=20){
  //     _requestNum=0;
  //     _request();
  //   }
  // }
}