import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/adjust/adjust_listener.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class RequestAdjust{
  String adjustToken;
  String distinctId;
  AdjustListener? _adjustListener;

  RequestAdjust({required this.adjustToken,required this.distinctId});

  setAdjustListener(AdjustListener adjustListener){
    _adjustListener=adjustListener;
  }

  request()async{
    if(null!=localAdjustIsBuyUser()){
      return;
    }
    _adjustListener?.beforeRequestAdjust();
    printLogByDebug("request adjust result ---> beforeRequestAdjust");
    Adjust.addSessionCallbackParameter("customer_user_id", distinctId);
    var adjustConfig = AdjustConfig(kDebugMode?"ih2pm2dr3k74":adjustToken, kDebugMode?AdjustEnvironment.sandbox:AdjustEnvironment.production);
    adjustConfig.attributionCallback=(AdjustAttribution attributionChangedData) {
      var network = attributionChangedData.network??"";
      printLogByDebug("request adjust result ---> $network");
      if(network.isNotEmpty&&!network.contains("Organic")&&null==localAdjustIsBuyUser()){
        LocalStorage.write(LocalStorageKey.localAdjustIsBuyUserKey, true);
        _adjustListener?.adjustChangeToBuyUser();
      }
      _adjustListener?.adjustResultCall(network);
    };
    adjustConfig.eventSuccessCallback= (AdjustEventSuccess eventSuccessData) {
      _adjustListener?.adjustEventCall(eventSuccessData);
    };
    Adjust.start(adjustConfig);
    _adjustListener?.startRequestAdjust();
    printLogByDebug("request adjust result ---> startRequestAdjust");
  }
}