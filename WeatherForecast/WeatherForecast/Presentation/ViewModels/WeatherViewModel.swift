//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import Combine
import MapKit
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var errorMessage: String?

    private var locationService: LocationService
    private let useCase: GetWeatherUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(locationService: LocationService, useCase: GetWeatherUseCaseProtocol) {
        self.useCase = useCase
        self.locationService = locationService
        // Listen for location updates
        locationService.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.fetchWeather(lat: location.latitude, lon: location.longitude)
            }
            .store(in: &cancellables)
        locationService.requestCurrentLocation()
    }

    func fetchWeather(lat: Double, lon: Double) {
        let endPoint: APIEndpoint = .currentWeather(lat: lat, lon: lon)
        useCase.execute(endpoint: endPoint, responseType: WeatherResponse.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.weatherData = response
                }
            })
            .store(in: &cancellables)
    }

    func selectLocation(_ completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            self.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude)
        }
    }
}
