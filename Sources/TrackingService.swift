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

public extension TrackingService {
    func setProperties(_ parameters: any EncodableParameters) {
        Task.detached {
            await setProperties(parameters)
        }
    }

    func onStep(_ parameters: any EncodableParameters) {
        Task.detached {
            await onStep(parameters)
        }
    }

    func exitStep(_ id: String) {
        Task.detached {
            await exitStep(id)
        }
    }

    func sendEvent(_ parameters: any EncodableParameters) {
        Task.detached {
            await sendEvent(parameters)
        }
    }
}

public protocol DeferredTrackingService: TrackingService {
    func setDeferredProperties(_ properties: [any EncodableParameters]) async
    func sendDeferredEvent(_ event: any EncodableParameters, byPropertiesID propertiesID: String) async
}

public extension DeferredTrackingService {
    func clearDeferredProperties() {
        Task.detached {
            await setDeferredProperties([])
        }
    }

    func setDeferredProperties(_ properties: [any EncodableParameters]) {
        Task.detached {
            await setDeferredProperties(properties)
        }
    }

    func sendDeferredEvent(_ event: any EncodableParameters, byPropertiesID propertiesID: String) {
        Task.detached {
            await sendDeferredEvent(event, byPropertiesID: propertiesID)
        }
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

public struct TrackingElement: EncodableParameters {
    public init(_ identifier: TrackingID, properties: [TrackingProperty] = []) {
        self.identifier = identifier
        self.properties = properties
    }

    public let identifier: TrackingID
    public let properties: [TrackingProperty]

    public var id: String { identifier.name }

    public func encode() -> [String: Any] {
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

    public init(key: String, json: (some Encodable)?, encoder: JSONEncoder = JSONEncoder.snakeCase) {
        self.key = key
        let encodedValue = try? json?.toDictionary(encoder: encoder)
        value = encodedValue
    }

    public let key: String
    public let value: Any?
}

public extension TrackingProperty {
    static func property(_ id: TrackingID, _ value: Any?) -> TrackingProperty {
        TrackingProperty(key: id.name, value: value)
    }

    static func property(_ id: TrackingID, json: (some Encodable)?, encoder: JSONEncoder = JSONEncoder.snakeCase) -> TrackingProperty {
        TrackingProperty(key: id.name, json: json, encoder: encoder)
    }
}

public extension TrackingService {
    func setProperties(_ id: TrackingID, value: Any?) {
        Task.detached {
            let element = TrackingElement(id, properties: [TrackingProperty(key: id.name, value: value)])
            await setProperties(element)
        }
    }

    func setProperties(_ id: TrackingID, properties: [TrackingProperty] = []) {
        Task.detached {
            let element = TrackingElement(id, properties: properties)
            await setProperties(element)
        }
    }

    func onStep(_ id: TrackingID, properties: [TrackingProperty] = []) {
        Task.detached {
            let element = TrackingElement(id, properties: properties)
            await onStep(element)
        }
    }

    func sendEvent(_ id: TrackingID, properties: [TrackingProperty] = []) {
        Task.detached {
            let element = TrackingElement(id, properties: properties)
            await sendEvent(element)
        }
    }
}

public extension DeferredTrackingService {
    func sendDeferredEvent(_ id: TrackingID, byPropertiesID propertiesID: String, withCustomProperties properties: [TrackingProperty] = []) {
        Task.detached {
            let element = TrackingElement(id, properties: properties)
            await sendDeferredEvent(element, byPropertiesID: propertiesID)
        }
    }
}

extension Encodable {
    func toDictionary(encoder: JSONEncoder = JSONEncoder.snakeCase) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data, options: [])

        guard let dictionary = object as? [String: Any] else {
            throw NSError(domain: "EncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to dictionary"])
        }

        return dictionary
    }
}

extension JSONEncoder {
    @usableFromInline
    static var snakeCase: JSONEncoder {
        let coder = JSONEncoder()
        coder.keyEncodingStrategy = .convertToSnakeCase
        return coder
    }
}
