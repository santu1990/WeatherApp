//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation
import Combine

class ForecastViewModel: ObservableObject {
    @Published var weatherForeCastData: ForeCastWeatherResponse?
    @Published var errorMessage: String?
    @Published var groupedForecast: [(String, [ForeCastWeatherEntry])] = []

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
                self?.fetchWeatherForeCast(lat: location.latitude, lon: location.longitude)
            }
            .store(in: &cancellables)
        locationService.requestCurrentLocation()
    }

    func fetchWeatherForeCast(lat: Double, lon: Double) {
        let endPoint: APIEndpoint = .forecast(lat: lat, lon: lon)
        useCase.execute(endpoint: endPoint, responseType: ForeCastWeatherResponse.self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.weatherForeCastData = response
                    self.groupForecastData()  // Update groupedForecast
                }
            })
            .store(in: &cancellables)
    }
    
    private func groupForecastData() {
        let grouped = Dictionary(grouping: weatherForeCastData?.list ?? []) { entry -> String in
            let date = Date(timeIntervalSince1970: TimeInterval(entry.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, MMM d"
            return formatter.string(from: date)
        }
        self.groupedForecast = grouped.sorted { $0.0 < $1.0 }
    }
}
