//
//  LiveActivityManager.swift
//  LiveActivityPushDemo
//
//  Created by guoxingxu on 2024/1/30.
//

import Foundation
import ActivityKit
import os.log
import UIKit


class LiveActivityManager: NSObject, ObservableObject {
    public static let shared: LiveActivityManager = LiveActivityManager()
    
    private var currentActivity: Activity<LiveActivityAttributes>? = nil
        
    override init() {
        super.init()
    }
       
    
    func getPushToStartToken() {
        if #available(iOS 17.2, *) {
            Task {
                for await data in Activity<LiveActivityAttributes>.pushToStartTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                            print("Activity PushToStart Token: \(token)")
                            //send this token to your notification server
                    }
            }
        }
    }
   
    func startActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("You can't start live activity.")
            return
        }
        
        do {
            let atttribute = LiveActivityAttributes(name:"APNsPush")
            let initialState = LiveActivityAttributes.ContentState(emoji: "😇")
            let activity = try Activity<LiveActivityAttributes>.request(
                attributes: atttribute,
                content: .init(state:initialState , staleDate: nil),
                pushType: .token
            )
            self.currentActivity = activity
            
            let pushToken = activity.pushToken // Returns nil.

            Task {
                
                for await pushToken in activity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") {
                        $0 + String(format: "%02x", $1)
                    }
                    print("Activity:\(activity.id) push token: \(pushTokenString)")
                    //send this token to your notification server
                }
            }
        } catch {
            print("start Activity From App:\(error)")
        }
    }
    
    func updateActivity(delay:Double, alert:Bool) {
        // register background task
        var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+delay) { [weak self] in
            UIApplication.shared.endBackgroundTask(backgroundTask)
            self?.updateActivity(alert: alert)
            
        }

    }
    

    
    func updateActivity(alert:Bool) {
        Task {
            guard let activity = currentActivity else {
                return
            }
            
            var alertConfig: AlertConfiguration? = nil
            let contentState: LiveActivityAttributes.ContentState = LiveActivityAttributes.ContentState(emoji: "🥰")
            
            if alert {
                alertConfig = AlertConfiguration(title: "Emoji Changed", body: "Open the app to check", sound: .default)
            }
            
            await activity.update(ActivityContent(state: contentState, staleDate: Date.now + 15, relevanceScore: alert ? 100 : 50), alertConfiguration: alertConfig)
        }
    }
    
    func endActivity(dismissTimeInterval: Double?) {
        Task {
            guard let activity = currentActivity else {
                return
            }
            let finalState = LiveActivityAttributes.ContentState(emoji: "✋✋")
            let dismissalPolicy: ActivityUIDismissalPolicy
            if let dismissTimeInterval = dismissTimeInterval {
                if dismissTimeInterval <= 0 {
                    dismissalPolicy = .immediate
                } else {
                    dismissalPolicy = .after(.now + dismissTimeInterval)
                }
            } else {
                dismissalPolicy = .default
            }
            
            await activity.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: dismissalPolicy)
        }
    }

}
