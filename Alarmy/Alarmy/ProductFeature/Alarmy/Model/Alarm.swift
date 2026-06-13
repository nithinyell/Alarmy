//
//  Alarm.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import Foundation

// MARK: - Alarm

struct Alarm: Identifiable {
    let id = UUID()
    var date: Date
    var sound: String
    var recurring: String
    var alarmSource: AlarmSource

    var displayTime: String {
        date.formatted(.dateTime.hour().minute())
    }

    var displayDate: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
}
