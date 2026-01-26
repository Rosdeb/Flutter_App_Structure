    import Flutter
    import UIKit
    import GoogleSignIn
    import FirebaseCore
    import FirebaseMessaging
    import UserNotifications

    @main
    @objc class AppDelegate: FlutterAppDelegate {
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {

      if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
          }

          // Configure Firebase
          FirebaseApp.configure()

          // Set FCM delegate
          Messaging.messaging().delegate = self

          // Register plugins ONLY ONCE
          GeneratedPluginRegistrant.register(with: self)

          // Request notification permissions
          if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: { granted, error in
                if let error = error {
                  print("❌ Notification permission error: \(error)")
                } else {
                  print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
                }
              }
            )
          }

            application.registerForRemoteNotifications()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

      override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance.handle(url) {
          return true
        }
        return super.application(app, open: url, options: options)
      }

      override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Safely unwrap the optional webpageURL
        if let url = userActivity.webpageURL, GIDSignIn.sharedInstance.handle(url) {
          return true
        }
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
      }

      override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          // Pass the token to Firebase Messaging
          Messaging.messaging().apnsToken = deviceToken

          // Optional: Print token for debugging
          let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
          let token = tokenParts.joined()
          print("✅ APNs Device Token: \(token)")
          print("✅ APNs token registered with FCM")
        }

         override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register for remote notifications: \(error.localizedDescription)")
          }
          override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
              let userInfo = notification.request.content.userInfo
              print("📬 Notification received in foreground: \(userInfo)")

              // Show notification even when app is in foreground
              if #available(iOS 14.0, *) {
                completionHandler([[.banner, .sound, .badge]])
              } else {
                completionHandler([[.alert, .sound, .badge]])
              }
            }
            override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                let userInfo = response.notification.request.content.userInfo
                print("📬 Notification tapped: \(userInfo)")
                // Handle notification tap - you can navigate to specific screen here
                // For example: send message to Flutter side via MethodChannel

                completionHandler()
              }
    }
    extension AppDelegate: MessagingDelegate {
      func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM Token received: \(fcmToken ?? "nil")")
         if let token = fcmToken {
                  print("FCM Token: \(token)")
                  // You can pass this token to Flutter side if needed
                  DispatchQueue.main.async {
                    let controller: FlutterViewController = (self.window?.rootViewController as! FlutterViewController)
                    let channel = FlutterMethodChannel(name: "fcm_token_channel", binaryMessenger: controller.binaryMessenger)
                    channel.invokeMethod("onToken", arguments: ["token": token])
                  }
                }
      }
    }