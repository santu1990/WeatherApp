//
//  DateFormatterHelper.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import Foundation

struct DateFormatterHelper {
    static func formatDate(_ timestamp: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
