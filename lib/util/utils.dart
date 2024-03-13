import 'package:flutter/foundation.dart';

printLogByDebug(Object? object){
  if (kDebugMode) {
    print(object);
  }
}