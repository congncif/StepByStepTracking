//
//  ConsoleTracker.swift
//  Pods
//
//  Created by NGUYEN CHI CONG on 7/5/25.
//

import Foundation

public final class ConsoleTracker: ExternalTrackingService {
    public init() {}

    public func logEvent(name: String, payload: [String: Any]) {
        #if DEBUG
            print("⏩ [\(Self.self)] [Tracking Event] [\(name)]\n\(payload)")
        #endif
    }
}
