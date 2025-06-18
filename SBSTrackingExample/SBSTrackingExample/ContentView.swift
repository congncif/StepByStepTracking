//
//  ContentView.swift
//  SBSTrackingExample
//
//  Created by NGUYEN CHI CONG on 14/6/25.
//

import StepByStepTracking
import SwiftUI

struct ContentView: View {
    @Environment(\.tracker) var tracker: TrackingService
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")

                Button("Send event") {
                    tracker.sendEvent(.events(.event1), properties: [
                        .property(.properties(.property1), "home1"),
                        .property(.properties(.property2), "home2")
                    ])
                }

                Button("Next") {
                    path.append(Int.random(in: 1 ... 100))
                }
            }
            .padding()
            .navigationTitle("Home")
            .navigationDestination(for: Int.self) { selection in
                NextView(selection: selection)
            }
            .onAppear {
                tracker.onStep(.steps(.step2), properties: [
                    .property(.properties(.userID), "SAMPLE_USER_ID")
                ])
            }
        }
    }
}

struct NextView: View {
    @Environment(\.tracker) var tracker: TrackingService

    let selection: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("You selected \(selection)")

            Button("Send event") {
                tracker.sendEvent(.events(.event2), properties: [
                    .property(.properties(.property2), "selection screen")
                ])
            }
        }
        .onAppear {
            tracker.onStep(.steps(.step1), properties: [
                .property(.properties(.selectionID), selection)
            ])
        }
    }
}

#Preview {
    ContentView()
}
