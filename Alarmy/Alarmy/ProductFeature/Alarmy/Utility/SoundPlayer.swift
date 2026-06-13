//
//  SoundPlayer.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import AVFoundation

final class SoundPlayer {
    static let shared = SoundPlayer()

    private init() {}

    func play(sound: String) {
        print("Playing selected sound:", sound)

        switch sound.lowercased() {
        case "party":
            AudioServicesPlaySystemSound(1025)

        case "ocean":
            AudioServicesPlaySystemSound(1104)

        case "white noise", "white-noise":
            AudioServicesPlaySystemSound(1103)

        case "brown noise", "brown-noise":
            AudioServicesPlaySystemSound(1107)

        default:
            AudioServicesPlaySystemSound(1005)
        }
    }

    func stop() {}
}
