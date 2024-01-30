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
                LiveActivityManager.shared.startActivity()
            }, label: {
                Text("Start Activity")
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
