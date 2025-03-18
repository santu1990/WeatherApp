//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import Combine
class WeatherRepository: WeatherRepositoryProtocol {
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol) {
        self.service = service
    }

    func fetch<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        return service.fetch(endpoint: endpoint, responseType: responseType)
    }
}
