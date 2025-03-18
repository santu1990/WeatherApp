//
//  SearchLocationUseCase.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation

protocol SearchLocationUseCaseProtocol {
    func searchLocation(query: String, completion: @escaping ([LocationResult]) -> Void)
}

class SearchLocationUseCase: SearchLocationUseCaseProtocol {
    private let repository: LocationRepositoryProtocol

    init(repository: LocationRepositoryProtocol = LocationRepository(service: LocationService())) {
        self.repository = repository
    }

    func searchLocation(query: String, completion: @escaping ([LocationResult]) -> Void) {
        repository.fetchLocations(query: query) { results in
            completion(results)
        }
    }
}
