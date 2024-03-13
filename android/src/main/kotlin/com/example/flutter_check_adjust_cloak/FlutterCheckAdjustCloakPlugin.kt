package com.example.flutter_check_adjust_cloak

import android.content.Context
import android.telephony.TelephonyManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** FlutterCheckAdjustCloakPlugin */
class FlutterCheckAdjustCloakPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var mApplicationContext:Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_check_adjust_cloak")
    channel.setMethodCallHandler(this)
    mApplicationContext=flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){
      "checkHasSim"->result.success(checkHasSim())
    }
  }

  private fun checkHasSim():Boolean{
    val telephonyManager = mApplicationContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    return when(telephonyManager.simState){
      TelephonyManager.SIM_STATE_READY -> true
      else -> false
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
