//
//  ExternalTrackingService.swift
//  Pods
//
//  Created by NGUYEN CHI CONG on 9/5/25.
//

import Foundation

public protocol ExternalTrackingService {
    func logEvent(name: String, payload: [String: Any])
}
