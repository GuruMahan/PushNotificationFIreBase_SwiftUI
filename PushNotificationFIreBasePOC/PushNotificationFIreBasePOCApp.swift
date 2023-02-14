//
//  PushNotificationFIreBasePOCApp.swift
//  PushNotificationFIreBasePOC
//
//  Created by Guru Mahan on 10/02/23.
//

import SwiftUI
import FirebaseCore
import Firebase
@main
struct PushNotificationFIreBasePOCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    
   let  gcmMessageIDKey = "gcm_message_id"
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      Messaging.messaging().delegate = self
      if #available(iOS 10.0, *){
          UNUserNotificationCenter.current().delegate = self
          
          let authOption: UNAuthorizationOptions = [.alert,.badge,.sound]
          UNUserNotificationCenter.current().requestAuthorization(options: authOption) { _, _ in }
         
      }else{
          let setting: UIUserNotificationSettings = UIUserNotificationSettings(types: [.sound,.badge,.alert], categories: nil)
          application.registerUserNotificationSettings(setting)
      }
      application.registerForRemoteNotifications()

    return true
  }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
   
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID===>: \(messageID)")
      }

      // Print full message.
      print("userInfo====>\(userInfo)")

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
   
}

extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let dataDict: [String: String] = ["token": fcmToken ?? "emptyToken"]
        
        print("dataDict====>\(dataDict)")
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
   
    let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID===>: \(messageID)")
        }
   
    print(userInfo)

        completionHandler([[.badge,.sound,.banner]])
  }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
    let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID===>: \(messageID)")
        }
    print(userInfo)
        completionHandler()
  }
}
