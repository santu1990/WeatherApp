//
//  LocationRepository.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation

protocol LocationRepositoryProtocol {
    func fetchLocations(query: String, completion: @escaping ([LocationResult]) -> Void)
}

class LocationRepository: LocationRepositoryProtocol {
    private let service: LocationService

    init(service: LocationService) {
        self.service = service
    }

    func fetchLocations(query: String, completion: @escaping ([LocationResult]) -> Void) {
        service.getLocations(query: query, completion: completion)
    }
}
