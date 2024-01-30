//
//  LiveActivityPushDemoApp.swift
//  LiveActivityPushDemo
//
//  Created by guoxingxu on 2024/1/30.
//

import SwiftUI
import ActivityKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LiveActivityManager.shared.getPushToStartToken()
        observeActivityPushToken()
        return true
    }
    
    
//    func applicationDidFinishLaunching(_ application: UIApplication) {
//
//    }
}

extension AppDelegate {
    func observeActivityPushToken() {
        Task {
            for await activityData in Activity<LiveActivityAttributes>.activityUpdates {
                Task {
                    for await tokenData in activityData.pushTokenUpdates {
                        let token = tokenData.map {String(format: "%02x", $0)}.joined()
                        print("Activity:\(activityData.id) Push token: \(token)")
                        //send this token to your notification server
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
