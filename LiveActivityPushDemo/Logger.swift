//
//  Logger.swift
//  LiveActivityPushDemo
//
//  Created by guoxingxu on 2024/10/11.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let liveactivity = Logger(subsystem: subsystem, category: "liveactivity")
}
