import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

printLogByDebug(String string){
  if (kDebugMode) {
    print(string);
  }
}

// Fluttertoast.showToast(
// msg: "kk==$kDebugMode",
// toastLength: Toast.LENGTH_SHORT,
// gravity: ToastGravity.CENTER,
// timeInSecForIosWeb: 1,
// backgroundColor: Colors.black45,
// textColor: Colors.white);