//
//  Alarmy.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import SwiftUI

// MARK: - AlarmyView

struct AlarmyView: View {
    @State private var showAddAlarm = false

    @State var viewModel: AlarmyViewModel

    init(viewModel: AlarmyViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
            case .failed:
                VStack {
                    Image(systemName: "cat")
                    Text("Something went wrong")
                        .foregroundStyle(.red)
                }
                .font(.title)
            case .loaded:
                alarmsBody
            }
        }
        .task {
            await viewModel.loadAlarmsIfRequired()
            viewModel.scheduler()
        }
        .onChange(of: viewModel.alarms.count) {
            viewModel.scheduler()
        }
        .fullScreenCover(item: Bindable(viewModel).activeAlarm) { alarm in
            AlarmRingingView(alarm: alarm) {
                viewModel.stopScheduler()
            }
        }
        .navigationTitle("Alarms")
        .toolbar {
            if viewModel.state == .loaded {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddAlarm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddAlarm) {
            NavigationStack {
                AlarmFormView(viewModel: viewModel, mode: .add)
            }
        }
    }
    
    @ViewBuilder
    var alarmsBody: some View {
        if viewModel.alarms.isEmpty {
            Text("Add Alarms")
                .font(.title)
                .foregroundStyle(.secondary)
        } else {
            List {
                ForEach(viewModel.alarms) { alarm in
                    NavigationLink {
                        AlarmFormView(viewModel: viewModel, mode: .edit(alarm))
                    } label: {
                        AlarmRowView(alarm: alarm)
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                }.onDelete { offset in
                    viewModel.deleteAlarm(at: offset)
                }
            }
        }
    }
}
