//
//  WeatherServiceProtocol.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import Combine

protocol WeatherServiceProtocol {
    func fetch<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error>
}
