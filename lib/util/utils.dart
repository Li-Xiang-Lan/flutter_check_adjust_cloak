import 'package:flutter/foundation.dart';

printLogByDebug(String string){
  if (kDebugMode) {
    print(string);
  }
}