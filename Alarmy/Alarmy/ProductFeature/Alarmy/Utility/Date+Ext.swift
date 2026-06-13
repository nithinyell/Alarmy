//
//  Date+Ext.swift
//  Alarmy
//
//  Created by Nithin on 2026-06-13.
//

import Foundation

// MARK: - DateFormatter

extension DateFormatter {
    static let alarmyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
