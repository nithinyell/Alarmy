//
//  AlarmRowView.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import SwiftUI

//MARK: - AlarmRowView

struct AlarmRowView: View {
    let alarm: Alarm

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(alarm.displayTime)
                    .font(.headline)

                Text(alarm.displayDate)
                    .font(.subheadline)

                Text(alarm.sound)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if alarm.alarmSource == .server {
                Label("Saved", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Label("Local", systemImage: "iphone")
                    .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}
