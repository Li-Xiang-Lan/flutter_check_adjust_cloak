import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/adjust/adjust_listener.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class RequestAdjust{
  String adjustToken;
  String distinctId;
  AdjustListener adjustListener;

  RequestAdjust({
    required this.adjustToken,
    required this.distinctId,
    required this.adjustListener,
  }){
    _request();
  }

  _request()async{
    adjustListener.beforeRequestAdjust();
    printLogByDebug("request adjust result ---> beforeRequestAdjust");
    Adjust.addSessionCallbackParameter("customer_user_id", distinctId);
    var adjustConfig = AdjustConfig(adjustToken, kDebugMode&&Platform.isAndroid?AdjustEnvironment.sandbox:AdjustEnvironment.production);
    adjustConfig.attributionCallback=(AdjustAttribution attributionChangedData) {
      var network = attributionChangedData.network??"";
      printLogByDebug("request adjust result ---> $network");
      if(network.isNotEmpty&&!network.contains("Organic")&&null==FlutterCheckAdjustCloak.instance.localAdjustIsBuyUser()){
        LocalStorage.write(LocalStorageKey.localAdjustIsBuyUserKey, true);
        adjustListener.adjustChangeToBuyUser();
      }
      adjustListener.adjustResultCall(network);
    };
    adjustConfig.eventSuccessCallback= (AdjustEventSuccess eventSuccessData) {
      adjustListener.adjustEventCall(eventSuccessData);
    };
    Adjust.start(adjustConfig);
    adjustListener.startRequestAdjust();
    printLogByDebug("request adjust result ---> startRequestAdjust");
  }
}