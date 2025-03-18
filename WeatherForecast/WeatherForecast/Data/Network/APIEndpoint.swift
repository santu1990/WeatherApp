//
//  APIEndpoint.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

enum APIEndpoint {
    case currentWeather(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)
    
    var urlString: String {
        switch self {
        case .currentWeather(let lat, let lon):
            return "\(APIConfig.baseURL)weather?lat=\(lat)&lon=\(lon)&appid=\(APIConfig.apiKey)&units=metric"
        case .forecast(let lat, let lon):
            return "\(APIConfig.baseURL)forecast?lat=\(lat)&lon=\(lon)&appid=\(APIConfig.apiKey)&units=metric"
        }
    }
}
