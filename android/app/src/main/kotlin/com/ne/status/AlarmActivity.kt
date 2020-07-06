package com.ne.status

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.media.MediaPlayer
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import kotlinx.android.synthetic.main.activity_alarm.*


class AlarmActivity : Activity() {
    companion object{
        const val TAG  = "AlarmActivity:tag"
    }

    val ringtone: MediaPlayer by lazy {
        return@lazy MediaPlayer.create(this, Settings.System.DEFAULT_RINGTONE_URI)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_alarm)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        } else {
            this.window.setFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        }

        ringtone.start()

        btnClose.setOnClickListener {
            stopAlarm()
        }
    }

    private fun stopAlarm() {
        ringtone.stop()
        finish()
    }

}