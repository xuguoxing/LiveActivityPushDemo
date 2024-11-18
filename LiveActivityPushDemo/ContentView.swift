//
//  ContentView.swift
//  LiveActivityPushDemo
//
//  Created by guoxingxu on 2024/1/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
            
            
            Button(action: {
                LiveActivityManager.shared.startLiveActivityWithToken()
            }, label: {
                Text("Start Activity - Push Type: .token")
            })
            
            Button(action: {
                LiveActivityManager.shared.startLiveActivityWithChannel(channelId: "CTrNsYq/Ee8AALLzHQaVlA==")
            }, label: {
                Text("Start Activity - Push Type: .channel")
            })
            
            Button(action: {
                
//                LiveActivityManager.shared.updateActivity(alert: false)
                LiveActivityManager.shared.updateActivity(delay: 5, alert: true)
            }, label: {
                Text("Update Activity")
            })
            
            Button(action: {
                LiveActivityManager.shared.endActivity(dismissTimeInterval: -1)
            }, label: {
                Text("End Activity")
            })
            
            Spacer().frame(height:80.0)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
