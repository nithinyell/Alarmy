//
//  AlarmRingingView.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import Foundation
import SwiftUI

//MARK: - AlarmRingingView

struct AlarmRingingView: View {
    let alarm: Alarm
    let onStop: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Text("⏰")
                .font(.system(size: 90))

            Text("Alarm Ringing")
                .font(.largeTitle)
                .bold()

            Text(alarm.displayTime)
                .font(.system(size: 48, weight: .bold))

            Text("Sound: \(alarm.sound)")
                .font(.title2)
                .foregroundStyle(.secondary)

            Button {
                onStop()
            } label: {
                Text("STOP")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 40)
        }
    }
}
