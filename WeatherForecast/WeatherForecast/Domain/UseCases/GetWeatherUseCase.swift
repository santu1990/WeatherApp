//
//  GetWeatherUseCase.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import Combine

class GetWeatherUseCase: GetWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        return repository.fetch(endpoint: endpoint, responseType: responseType)
    }
}
