//
//  AlarmScheduler.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import Foundation

//MARK: - AlarmScheduler

@Observable
final class AlarmScheduler {
    var activeAlarm: Alarm?

    private var timer: Timer?

    func scheduleNextAlarm(from alarms: [Alarm]) {
        timer?.invalidate()

        guard let nextAlarm = alarms
            .filter({ $0.date > Date() })
            .sorted(by: { $0.date < $1.date })
            .first
        else {
            return
        }

        let interval = nextAlarm.date.timeIntervalSinceNow

        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: false
        ) { [weak self] _ in
            self?.activeAlarm = nextAlarm
            SoundPlayer.shared.play(sound: nextAlarm.sound)
        }
    }

    func stopAlarm() {
        activeAlarm = nil
        SoundPlayer.shared.stop()
    }

    deinit {
        timer?.invalidate()
    }
}
