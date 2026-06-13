//
//  AlarmResponse.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

// MARK: - AlarmResponse

struct AlarmResponse: Decodable {
    let timestamp: String
    let sound: String
    let recurring: String
}
