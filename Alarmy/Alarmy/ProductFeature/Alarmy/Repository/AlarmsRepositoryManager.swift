//
//  AlarmsRepositoryManager.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import Foundation
import NetworkManager

// MARK: - AlarmsRepositoryManager

protocol AlarmsRepositoryManager {
    func fetchAlarms() async throws -> [Alarm]
}

// MARK: - AlarmsRepository

struct AlarmsRepository: AlarmsRepositoryManager {
    let networkManager: NetworkManager

    func fetchAlarms() async throws -> [Alarm] {
        guard let data = try await networkManager.request(Endpoints.alarms.rawValue) else {
            return []
        }

        let responses = try JSONDecoder().decode([AlarmResponse].self, from: data)

        return responses.map {
            Alarm(
                date: DateFormatter.alarmyFormatter.date(from: $0.timestamp) ?? Date(),
                sound: $0.sound,
                recurring: $0.recurring,
                alarmSource: .server
            )
        }
    }
}
