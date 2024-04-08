import 'dart:async';
import 'package:flutter_check_adjust_cloak/cloak/cloak_listener.dart';
import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class RequestCloak{
  String cloakPath;
  String normalModeStr;
  String blackModeStr;
  CloakListener cloakListener;
  var _requestNum=0;

  RequestCloak({
    required this.cloakPath,
    required this.normalModeStr,
    required this.blackModeStr,
    required this.cloakListener,
  });

  request()async{
    if(_requestNum>=20){
      return;
    }
    cloakListener.firstRequestCloak();
    printLogByDebug("request cloak result--> $cloakPath");
    var result = await DioManager.instance.requestGet(url: cloakPath);
    printLogByDebug("request cloak result--> $result");
    if(result.isNotEmpty&&(result==normalModeStr||result==blackModeStr)){
      LocalStorage.write(LocalStorageKey.localCloakIsNormalUserKey, result==normalModeStr);
      cloakListener.firstRequestCloakSuccess();
    }else{
      Future.delayed(const Duration(milliseconds: 1000),(){
        _requestNum++;
        request();
      });
    }
  }
}