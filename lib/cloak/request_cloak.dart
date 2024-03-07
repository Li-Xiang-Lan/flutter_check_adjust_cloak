import 'dart:async';
import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class RequestCloak{
  String cloakPath;
  String normalModeStr;
  String blackModeStr;
  var _requestNum=0;

  RequestCloak({
    required this.cloakPath,
    required this.normalModeStr,
    required this.blackModeStr
  });

  request()async{
    if(_requestNum>=20||getLocalCloak().isNotEmpty){
      return;
    }
    var result = await DioManager.instance.requestGet(url: cloakPath);
    printLogByDebug("request cloak result--> $result");
    if(result.isNotEmpty&&(result==normalModeStr||result==blackModeStr)){
      LocalStorage.write(LocalStorageKey.cloakLocalKey, result);
    }else{
      Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        timer.cancel();
        _requestNum++;
        request();
      });
    }
  }

  String getLocalCloak()=>LocalStorage.read<String>(LocalStorageKey.cloakLocalKey)??"";

  bool isBlack(){
    var localCloak = getLocalCloak();
    return localCloak.isEmpty||localCloak==blackModeStr;
  }
}