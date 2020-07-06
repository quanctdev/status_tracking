package com.ne.status.plugin

import com.google.firebase.iid.FirebaseInstanceId
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FcmPlugin(binaryMessenger: BinaryMessenger, channelName: String) : Plugin(binaryMessenger, channelName) {

    init {
        MethodChannel(binaryMessenger, channelName).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getDeviceToken") {
            FirebaseInstanceId.getInstance().instanceId.addOnSuccessListener { instanceIdResult ->
                result.success(instanceIdResult.token)
            }
        } else {
            result.notImplemented()
        }
    }
}