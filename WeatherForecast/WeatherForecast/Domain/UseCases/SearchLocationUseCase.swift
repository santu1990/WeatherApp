//
//  SearchLocationUseCase.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//


import Foundation

class SearchLocationUseCase {
    private let repository: LocationRepository

    init(repository: LocationRepository = LocationRepository(service: LocationService())) {
        self.repository = repository
    }

    func searchLocation(query: String, completion: @escaping ([LocationResult]) -> Void) {
        repository.fetchLocations(query: query) { results in
            completion(results)
        }
    }
}
