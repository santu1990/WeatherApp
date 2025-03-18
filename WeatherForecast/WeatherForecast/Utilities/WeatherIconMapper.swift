//
//  WeatherIconMapper.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//


import Foundation

struct WeatherIconMapper {
    static func iconName(for icon: String) -> String {
        switch icon {
            case "01d", "01n": return "sun.max.fill" // Clear sky
            case "02d", "02n": return "cloud.sun.fill" // Few clouds
            case "03d", "03n": return "cloud.fill" // Scattered clouds
            case "04d", "04n": return "smoke.fill" // Broken clouds
            case "09d", "09n": return "cloud.rain.fill" // Showers
            case "10d": return "cloud.sun.rain.fill" // Light rain with sun
            case "10n": return "cloud.moon.rain.fill" // Light rain with moon
            case "11d", "11n": return "cloud.bolt.fill" // Thunderstorms
            case "13d", "13n": return "snow" // Snow
            case "50d", "50n": return "cloud.fog.fill" // Fog
            default: return "questionmark" // Unknown or unsupported icon
        }
    }
}
