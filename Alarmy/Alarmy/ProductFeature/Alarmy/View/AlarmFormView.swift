//
//  AlarmFormView.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import SwiftUI

//MARK: - AlarmFormView

struct AlarmFormView: View {
    enum Mode {
        case add
        case edit(Alarm)
    }

    @Environment(\.dismiss) private var dismiss

    let mode: Mode
    let viewModel: AlarmyViewModel

    @State private var selectedDate: Date
    @State private var sound: String
    @State private var recurring: String

    private let sounds = ["bell", "party", "ocean", "white-noise", "brown-noise"]

    init(viewModel: AlarmyViewModel, mode: Mode) {
        self.viewModel = viewModel
        self.mode = mode

        switch mode {
        case .add:
            _selectedDate = State(initialValue: Date())
            _sound = State(initialValue: "bell")
            _recurring = State(initialValue: "one-time")

        case .edit(let alarm):
            _selectedDate = State(initialValue: alarm.date)
            _sound = State(initialValue: alarm.sound)
            _recurring = State(initialValue: alarm.recurring)
        }
    }

    var body: some View {
        Form {
            Section("Choose Time") {
                DatePicker(
                    "Time",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .pickerStyle(.wheel)
            }

            Section("Choose Sound") {
                Picker("Sound", selection: $sound) {
                    ForEach(sounds, id: \.self) {
                        Text($0).tag($0)
                    }
                }
                
                Button("Preview Sound") {
                    SoundPlayer.shared.play(sound: sound)
                }
            }

            Section("Repeat") {
                Picker("Recurring", selection: $recurring) {
                    Text("One Time").tag("one-time")
                    Text("Daily").tag("daily")
                    Text("Weekly").tag("weekly")
                    Text("Yearly").tag("yearly")
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(buttonTitle) {
                    save()
                }
            }
        }
    }

    private var title: String {
        switch mode {
        case .add:
            return "Add Alarm"
        case .edit:
            return "Edit Alarm"
        }
    }

    private var buttonTitle: String {
        switch mode {
        case .add:
            return "Save"
        case .edit:
            return "Update"
        }
    }

    private func save() {
        switch mode {
        case .add:
            viewModel.addAlarm(
                date: selectedDate,
                sound: sound,
                recurring: recurring
            )

        case .edit(let alarm):
            viewModel.updateAlarm(
                alarm,
                date: selectedDate,
                sound: sound,
                recurring: recurring
            )
        }

        dismiss()
    }
}
