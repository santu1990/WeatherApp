//
//  LocationResult.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation

struct LocationResult: Identifiable {
    let id = UUID()
    let title: String
    let latitude: Double
    let longitude: Double
}
