//
//  AlarmyViewModel.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import SwiftUI
import Analytics

//MARK: - AlarmyViewModel

@Observable
final class AlarmyViewModel {
    enum ViewState {
        case loading
        case loaded
        case failed
    }

    private let repository: AlarmsRepositoryManager
    private let analytics: AnalyticsManager
    let alarmScheduler = AlarmScheduler()
    
    var alarms: [Alarm] = []
    var state: ViewState = .loading

    init(repository: AlarmsRepositoryManager, analytics: AnalyticsManager) {
        self.repository = repository
        self.analytics = analytics
    }

    var activeAlarm: Alarm? {
        get { alarmScheduler.activeAlarm }
        set { alarmScheduler.activeAlarm = newValue }
    }

    func loadAlarmsIfRequired() async {
        guard alarms.isEmpty else { return }
        
        do {
            alarms = try await repository.fetchAlarms()
            sortAlarms()
            state = .loaded
            await analytics.save(event: AnalyticEvent(eventType: .screenLoad("Alarmy View")))
        } catch {
            print(error.localizedDescription)
            state = .failed
        }
    }

    func addAlarm(date: Date, sound: String, recurring: String) {
        alarms.append(
            Alarm(
                date: date,
                sound: sound,
                recurring: recurring,
                alarmSource: .local
            )
        )

        sortAlarms()
        scheduler()
    }

    func updateAlarm(_ alarm: Alarm, date: Date, sound: String, recurring: String) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else {
            return
        }

        alarms[index].date = date
        alarms[index].sound = sound
        alarms[index].recurring = recurring
        sortAlarms()
        scheduler()
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }

    func scheduler() {
        alarmScheduler.scheduleNextAlarm(from: alarms)
    }
    
    func stopScheduler() {
        alarmScheduler.stopAlarm()
    }
    
    private func sortAlarms() {
        alarms.sort {
            nextTriggerDate(for: $0) < nextTriggerDate(for: $1)
        }
    }

    private func nextTriggerDate(for alarm: Alarm) -> Date {
        let now = Date()
        let calendar = Calendar.current

        if alarm.date > now {
            return alarm.date
        }

        switch alarm.recurring {
        case "daily":
            return calendar.nextDate(
                after: now,
                matching: calendar.dateComponents([.hour, .minute], from: alarm.date),
                matchingPolicy: .nextTime
            ) ?? alarm.date

        case "weekly":
            return calendar.nextDate(
                after: now,
                matching: calendar.dateComponents([.weekday, .hour, .minute], from: alarm.date),
                matchingPolicy: .nextTime
            ) ?? alarm.date

        case "yearly":
            return calendar.nextDate(
                after: now,
                matching: calendar.dateComponents([.month, .day, .hour, .minute], from: alarm.date),
                matchingPolicy: .nextTime
            ) ?? alarm.date

        default:
            return alarm.date
        }
    }
}
