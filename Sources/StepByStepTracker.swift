//
//  StepByStepTracker.swift
//  Pods
//
//  Created by NGUYEN CHI CONG on 7/5/25.
//

import Foundation

public actor StepByStepTracker: DeferredTrackingService {
    let externalTracker: ExternalTrackingService

    public init(externalTracker: any ExternalTrackingService) {
        self.externalTracker = externalTracker
    }

    var properties: [String: any EncodableParameters] = [:]
    var steps: [any EncodableParameters] = []
    var deferredProperties: [String: any EncodableParameters] = [:]

    public func setProperties(_ parameters: any EncodableParameters) async {
        properties[parameters.id] = parameters
    }

    public func onStep(_ parameters: any EncodableParameters) async {
        await exitStep(parameters.id)
        steps.append(parameters)
    }

    public func exitStep(_ id: String) async {
        if let index = steps.firstIndex(where: { $0.id == id }) {
            steps.removeSubrange(index...)
        }
    }

    public func sendEvent(_ parameters: any EncodableParameters) async {
        let payload = await buildPayload(for: parameters)
        externalTracker.logEvent(name: parameters.id, payload: payload)
    }

    public func setDeferredProperties(_ properties: [any EncodableParameters]) async {
        let reducedProperties = properties.reduce([:]) { partialResult, item in
            partialResult.merging([item.id: item], uniquingKeysWith: { $1 })
        }
        deferredProperties.merge(reducedProperties, uniquingKeysWith: { $1 })
    }

    public func sendDeferredEvent(_ event: any EncodableParameters, byPropertiesID propertiesID: String) async {
        if let deferredProperties = deferredProperties[propertiesID] {
            let allProperties = deferredProperties.encode().merging(event.encode(), uniquingKeysWith: { $1 })

            let finalEvent = TrackingRawElement(
                id: event.id,
                properties: allProperties
            )

            await sendEvent(finalEvent)
        } else {
            #if DEBUG
                print("⚠️ [StepByStepTracker] The tracking event \(event) with propertiesID \(propertiesID) not available -> Fallback to send the pure event!")
            #endif
            await sendEvent(event)
        }
    }

    private func buildPayload(for eventParameters: any EncodableParameters) async -> [String: Any] {
        let propertiesPayload = properties.reduce([:]) { partialResult, item in
            partialResult.merging(item.value.encode(), uniquingKeysWith: { $1 })
        }

        let stepsPayload = steps.reduce([:]) { partialResult, item in
            partialResult.merging(item.encode(), uniquingKeysWith: { $1 })
        }

        let eventPayload = eventParameters.encode()

        return propertiesPayload
            .merging(stepsPayload, uniquingKeysWith: { $1 })
            .merging(eventPayload, uniquingKeysWith: { $1 })
    }
}
