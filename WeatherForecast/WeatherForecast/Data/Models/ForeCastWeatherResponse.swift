//
//  ForeCastWeatherResponse.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation

struct ForeCastWeatherResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForeCastWeatherEntry]
    let city: ForeCastCity
}

struct ForeCastWeatherEntry: Codable {
    let timestamp: Int
    let main: ForeCastMainWeather
    let weather: [ForeCastWeather]
    let clouds: ForeCastClouds
    let wind: ForeCastWind
    let visibility: Int
    let pop: Double
    let sys: ForeCastSys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

struct ForeCastMainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct ForeCastWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct ForeCastClouds: Codable {
    let all: Int
}

struct ForeCastWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct ForeCastSys: Codable {
    let pod: String
}

struct ForeCastCity: Codable {
    let id: Int
    let name: String
    let coord: ForeCastCoord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

struct ForeCastCoord: Codable {
    let lat: Double
    let lon: Double
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}
