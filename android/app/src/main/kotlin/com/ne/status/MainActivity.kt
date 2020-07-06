package com.ne.status

import androidx.annotation.NonNull
import com.ne.status.plugin.FcmPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        FcmPlugin(binaryMessenger, "flutter.app/plugin")
    }
}
