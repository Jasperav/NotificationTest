import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate,
    UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [
        UIApplication.LaunchOptionsKey: Any
        ]? =
        nil
    ) -> Bool {
        assert(Thread.isMainThread)

        print("Preparing to configure Firebase")

        // Ask the user to accept push notifications
        // This will be only asked once according to the docs
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
                .requestAuthorization(options: [
                    .alert,
                    .sound,
                    .badge,
                ]) { _, _ in
                    // This is not really important
                }

        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        return true
    }

    func messaging(
        _: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("New firebase registration token: \(String(describing: fcmToken))")
    }

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo

        print("Will present: \(userInfo)")
        
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping ()
        -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        print("Did receive: \(userInfo)")

        completionHandler()
    }

    func application(
        _: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error.localizedDescription)")
    }
}
