//
//  WeatherIconMapper.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation

struct WeatherIconMapper {
    static func iconName(for icon: String) -> String {
        let iconMapping: [String: String] = [
            "01d": "sun.max.fill", "01n": "sun.max.fill", // Clear sky
            "02d": "cloud.sun.fill", "02n": "cloud.sun.fill", // Few clouds
            "03d": "cloud.fill", "03n": "cloud.fill", // Scattered clouds
            "04d": "smoke.fill", "04n": "smoke.fill", // Broken clouds
            "09d": "cloud.rain.fill", "09n": "cloud.rain.fill", // Showers
            "10d": "cloud.sun.rain.fill", // Light rain with sun
            "10n": "cloud.moon.rain.fill", // Light rain with moon
            "11d": "cloud.bolt.fill", "11n": "cloud.bolt.fill", // Thunderstorms
            "13d": "snow", "13n": "snow", // Snow
            "50d": "cloud.fog.fill", "50n": "cloud.fog.fill" // Fog
        ]

        return iconMapping[icon] ?? "questionmark" // Unknown or unsupported icon
    }
}
