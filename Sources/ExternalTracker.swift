//
//  ExternalTracker.swift
//  Pods
//
//  Created by NGUYEN CHI CONG on 14/6/25.
//

import Foundation

public final class ExternalTracker: ExternalTrackingService {
    private var trackers: [ExternalTrackingService]

    public init(trackers: [ExternalTrackingService]) {
        self.trackers = trackers
    }

    public func append(_ tracker: ExternalTrackingService) {
        self.trackers.append(tracker)
    }

    public func logEvent(name: String, payload: [String: Any]) {
        self.trackers.forEach {
            $0.logEvent(name: name, payload: payload)
        }
    }
}

public extension ExternalTrackingService {
    func combined(_ other: ExternalTrackingService) -> ExternalTrackingService {
        if let source = self as? ExternalTracker {
            source.append(other)
            return source
        } else {
            return ExternalTracker(trackers: [self, other])
        }
    }

    static var console: ExternalTrackingService {
        ConsoleTracker()
    }
}
