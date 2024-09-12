import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';

class RequestAdjust{
  String adjustToken;
  String distinctId;
  bool adjustSandbox;
  CheckListener? checkListener;

  RequestAdjust({
    required this.adjustToken,
    required this.distinctId,
    required this.adjustSandbox,
    required this.checkListener,
  }){
    _request();
  }

  _request()async{
    checkListener?.beforeRequestAdjust();
    printLogByDebug("request adjust result ---> beforeRequestAdjust");
    Adjust.addSessionCallbackParameter("customer_user_id", distinctId);
    var adjustConfig = AdjustConfig(adjustToken, adjustSandbox?AdjustEnvironment.sandbox:AdjustEnvironment.production);
    adjustConfig.attributionCallback=(AdjustAttribution attributionChangedData) {
      var network = attributionChangedData.network??"";
      printLogByDebug("request adjust result ---> $network");
      if(network.isNotEmpty&&!network.contains("Organic")&&null==FlutterCheckAdjustCloak.instance.localAdjustIsBuyUser()){
        LocalStorage.write(LocalStorageKey.localAdjustIsBuyUserKey, true);
        checkListener?.adjustChangeToBuyUser();
      }
      checkListener?.adjustResultCall(network);
    };
    adjustConfig.eventSuccessCallback= (AdjustEventSuccess eventSuccessData) {
      checkListener?.adjustEventCall(eventSuccessData);
    };
    Adjust.start(adjustConfig);
    checkListener?.startRequestAdjust();
    printLogByDebug("request adjust result ---> startRequestAdjust");
  }
}