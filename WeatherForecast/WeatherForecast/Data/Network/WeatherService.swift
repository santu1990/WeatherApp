//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    func fetch<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint.urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
