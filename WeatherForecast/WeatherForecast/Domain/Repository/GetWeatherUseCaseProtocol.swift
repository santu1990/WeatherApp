//
//  GetWeatherUseCaseProtocol.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//
import Combine

protocol GetWeatherUseCaseProtocol {
    func execute<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error>
}
