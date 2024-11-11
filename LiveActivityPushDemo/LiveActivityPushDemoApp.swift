//
//  LiveActivityPushDemoApp.swift
//  LiveActivityPushDemo
//
//  Created by guoxingxu on 2024/1/30.
//

import SwiftUI
import ActivityKit
import OSLog

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LiveActivityManager.shared.getPushToStartToken()
        observeActivityPushTokenAndState()
                
        let authOptions: UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            print(granted,error ?? "")
        }
        application.registerForRemoteNotifications()

        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print("APNs device token: \(deviceTokenString)")
    }
    
    
//    func applicationDidFinishLaunching(_ application: UIApplication) {
//
//    }
}

extension AppDelegate {
    func observeActivityPushTokenAndState() {
        Task {
            for await activity in Activity<LiveActivityAttributes>.activityUpdates {
                Task {
                    for await tokenData in activity.pushTokenUpdates {
                        let token = tokenData.map {String(format: "%02x", $0)}.joined()
                        print("Observer Activity:\(activity.id) Push token: \(token)")
                        Logger.liveactivity.info("Observer Activity:\(activity.id, privacy: .public) Push token: \(token,privacy: .public)")
                        //send this token to your notification server
                    }
                }
                
                Task {
                    for await state in activity.activityStateUpdates {
                        print("Observer Activity:\(activity.id) state:\(state)")
                        let stateLog = "Observer Activity:\(activity.id) state:\(state)"
                        Logger.liveactivity.info("\(stateLog,privacy: .public)")
                        if state == .stale {
                            LiveActivityManager.endActivity(activity: activity, dismissTimeInterval: 0)
                        }
                    }
                }
                
            }
        }
    }
}


@main
struct LiveActivityPushDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
