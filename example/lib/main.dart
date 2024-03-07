import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: ()async{
                    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
                    var ts = DateTime.now().millisecondsSinceEpoch;
                    var deviceModel = await FlutterTbaInfo.instance.getDeviceModel();
                    // var bundleId = await FlutterTbaInfo.instance.getBundleId();
                    var bundleId = "com.word.tap.quiz";
                    var osVersion = await FlutterTbaInfo.instance.getOsVersion();
                    var gaid = await FlutterTbaInfo.instance.getGaid();
                    var androidId = await FlutterTbaInfo.instance.getAndroidId();
                    var appVersion = await FlutterTbaInfo.instance.getAppVersion();
                    var operator = await FlutterTbaInfo.instance.getOperator();
                    var url="https://wallaby.wordtap.link/locust/bound?aden=$distinctId&twigging=$ts&brock=$deviceModel&proctor=$bundleId&bandgap=$osVersion&bengal=$gaid&wingbeat=$androidId&improper=aeolian&karyatid=$appVersion&rockaway=$operator";
                    FlutterCheckAdjustCloak.instance.setConfigAndInit(
                        cloakPath: url,
                        normalModeStr: "alluvium",
                        blackModeStr: "trigram",
                        adjustToken: "",
                        distinctId: distinctId
                    );
                  },
                  child: const Text("init",style: TextStyle(fontSize: 20),)
              ),
              TextButton(
                  onPressed: (){
                    FlutterCheckAdjustCloak.instance.checkType();
                  },
                  child: const Text("check type",style: TextStyle(fontSize: 20),)
              ),
              TextButton(
                  onPressed: (){
                    FlutterCheckAdjustCloak.instance.forceBuyUser(true);
                  },
                  child: const Text("force buy user",style: TextStyle(fontSize: 20),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
