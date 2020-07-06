package com.ne.status.plugin

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

abstract class Plugin constructor(val binaryMessenger: BinaryMessenger, val channelName: String) : MethodChannel.MethodCallHandler