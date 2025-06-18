//
//  SBSTrackingExampleApp.swift
//  SBSTrackingExample
//
//  Created by NGUYEN CHI CONG on 14/6/25.
//

import StepByStepTracking
import SwiftUI

private struct SBSTrackingKey: EnvironmentKey {
    static let defaultValue: TrackingService = StepByStepTracker(externalTracker: ConsoleTracker())
}

extension EnvironmentValues {
    var tracker: TrackingService {
        get { self[SBSTrackingKey.self] }
        set { self[SBSTrackingKey.self] = newValue }
    }
}

@main
struct SBSTrackingExampleApp: App {
    let tracker: TrackingService = SBSTrackingKey.defaultValue

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.tracker, tracker)
        }
    }
}
