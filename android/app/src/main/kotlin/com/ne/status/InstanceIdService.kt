package com.ne.status

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

/**
 * Created by クアン on 05/06/2019.
 */

class InstanceIdService : FirebaseMessagingService() {
    private fun sendRegistrationToServer(refreshedToken: String?) {

    }

    override fun onNewToken(s: String) {
        super.onNewToken(s)

        sendRegistrationToServer(s)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
    }
}
