//
//  TrackingService.swift
//  Pods
//
//  Created by NGUYEN CHI CONG on 7/5/25.
//

import Foundation

public protocol TrackingService {
    func setProperties(_ parameters: any EncodableParameters) async
    func onStep(_ parameters: any EncodableParameters) async
    func exitStep(_ id: String) async
    func sendEvent(_ parameters: any EncodableParameters) async
}

public protocol DeferredTrackingService: TrackingService {
    func setDeferredProperties(_ properties: [any EncodableParameters]) async
    func sendDeferredEvent(_ event: any EncodableParameters, byPropertiesID propertiesID: String) async
}

public extension DeferredTrackingService {
    func clearDeferredProperties() async {
        await setDeferredProperties([])
    }
}

struct TrackingRawElement: EncodableParameters {
    let id: String
    let properties: [String: Any]

    func encode() -> [String: Any] {
        properties
    }
}

public protocol EncodableParameters {
    var id: String { get }

    func encode() -> [String: Any]
}

struct TrackingElement: EncodableParameters {
    init(_ identifier: TrackingID, properties: [TrackingProperty] = []) {
        self.identifier = identifier
        self.properties = properties
    }

    let identifier: TrackingID
    let properties: [TrackingProperty]

    var id: String { identifier.name }

    func encode() -> [String: Any] {
        properties.reduce([:]) { partialResult, item in
            if let value = item.value {
                partialResult.merging([item.key: value], uniquingKeysWith: { $1 })
            } else {
                partialResult
            }
        }
    }
}

public struct TrackingID: ExpressibleByStringLiteral {
    public init(name: String) {
        self.name = name
    }

    public init(stringLiteral value: StringLiteralType) {
        name = value
    }

    public let name: String
}

public struct TrackingProperty {
    public init(key: String, value: Any? = nil) {
        self.key = key
        self.value = value
    }

    public let key: String
    public let value: Any?
}

public extension TrackingProperty {
    static func property(_ id: TrackingID, _ value: Any?) -> TrackingProperty {
        TrackingProperty(key: id.name, value: value)
    }
}

public extension TrackingService {
    func setProperties(_ id: TrackingID, value: Any?) async {
        let element = TrackingElement(id, properties: [TrackingProperty(key: id.name, value: value)])
        await setProperties(element)
    }

    func onStep(_ id: TrackingID, properties: [TrackingProperty] = []) async {
        let element = TrackingElement(id, properties: properties)
        await onStep(element)
    }

    func sendEvent(_ id: TrackingID, properties: [TrackingProperty] = []) async {
        let element = TrackingElement(id, properties: properties)
        await sendEvent(element)
    }
}

public extension DeferredTrackingService {
    func sendDeferredEvent(_ id: TrackingID, byPropertiesID propertiesID: String, withCustomProperties properties: [TrackingProperty] = []) async {
        let element = TrackingElement(id, properties: properties)
        await sendDeferredEvent(element, byPropertiesID: propertiesID)
    }
}
