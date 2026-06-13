// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum EventType: Sendable {
    case screenLoad(String)
    case buttonClick
}

public struct AnalyticEvent: Sendable {
    let timeStamp = Date()
    let properties: [String: String] = [:]
    let eventType: EventType
    
    public init(eventType: EventType) {
        self.eventType = eventType
    }
}

public protocol AnalyticsManager {
    func save(event: AnalyticEvent) async
}

public actor Analytics: AnalyticsManager {
    
    public init() {}
    
    public func save(event: AnalyticEvent) async {
        // Send to firebase or dynatrace
        print(event)
    }
}
