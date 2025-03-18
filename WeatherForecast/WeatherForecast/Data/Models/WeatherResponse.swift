//
//  WeatherResponse.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import SwiftUI

struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: TimeInterval
    let sys: SystemInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct SystemInfo: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct Weather: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
