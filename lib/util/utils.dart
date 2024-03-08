import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage.dart';
import 'package:flutter_check_adjust_cloak/local_storage/local_storage_key.dart';

printLogByDebug(String string){
  if (kDebugMode) {
    print(string);
  }
}

///true=normal user
///false=black user
///null=no data
bool? localCloakIsNormalUser()=>LocalStorage.read<bool>(LocalStorageKey.localCloakIsNormalUserKey);

///true=buy user
///null=no data
bool? localAdjustIsBuyUser()=>LocalStorage.read<bool>(LocalStorageKey.localAdjustIsBuyUserKey);