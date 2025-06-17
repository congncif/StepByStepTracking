//
//  TrackingStepNames.swift
//  SBSTrackingExample
//
//  Created by NGUYEN CHI CONG on 14/6/25.
//

import Foundation

enum TrackingStepNames: String {
    case step1
    case step2
}

enum TrackingEventNames: String {
    case event1
    case event2
}

enum TrackingPropertyNames: String {
    case property1
    case property2
    case userID
    case selectionID
}

// MARK: - Extensions

import StepByStepTracking

extension TrackingID {
    static func steps(_ name: TrackingStepNames) -> TrackingID {
        .init(name: name.rawValue)
    }

    static func events(_ name: TrackingEventNames) -> TrackingID {
        .init(name: name.rawValue)
    }

    static func properties(_ name: TrackingPropertyNames) -> TrackingID {
        .init(name: name.rawValue)
    }
}
