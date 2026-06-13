//
//  AlarmyApp.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import SwiftUI
import NetworkManager
import Analytics

@main
struct Alarmy: App {
    private let networkManager = Network()
    private let analytics = Analytics()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AlarmyView(
                    viewModel: makeViewModel()                )
            }
        }
    }
    
    private func makeViewModel() -> AlarmyViewModel {
        AlarmyViewModel(repository: AlarmsRepository(networkManager: networkManager),
                        analytics: analytics)
    }
}
