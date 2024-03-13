import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';

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
                    // FlutterCheckAdjustCloak.instance.setConfigAndInit(
                    //     cloakPath: url,
                    //     normalModeStr: "",
                    //     blackModeStr: "",
                    //     adjustToken: "",
                    //     distinctId: distinctId
                    // );
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
              TextButton(
                  onPressed: ()async{

                  },
                  child: const Text("init firebase",style: TextStyle(fontSize: 20),)
              ),
              TextButton(
                  onPressed: ()async{
                    var bool = await FlutterCheckAdjustCloak.instance.checkHasSim();
                    print("kk===${bool}");
                  },
                  child: const Text("getFirebaseConf",style: TextStyle(fontSize: 20),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
