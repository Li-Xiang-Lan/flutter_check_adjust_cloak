import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';

class RequestReferrer{
  var _referrerRequestNum=0;
  RequestReferrer(){
    _request();
  }

  _request()async{
    if(Platform.isIOS||_referrerRequestNum>=15){
      return;
    }
    var referrer = LocalStorage.read<String>(LocalStorageKey.localReferrerKey)??"";
    if(referrer.isNotEmpty){
      return;
    }
    try{
      var referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      var referrerStr=referrerDetails.installReferrer??"";
      if(referrerStr.isNotEmpty){
        LocalStorage.write(LocalStorageKey.localReferrerKey, referrerStr);
      }else{
        _referrerRequestNum++;
        _request();
      }
    }catch(e){
      _referrerRequestNum++;
      _request();
    }
  }
}