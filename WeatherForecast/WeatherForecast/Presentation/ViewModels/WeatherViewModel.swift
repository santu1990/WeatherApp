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
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            self.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude)
        }
    }

    let sampleForecastData = ForeCastWeatherResponse(
        cod: "200",
        message: 0,
        cnt: 5,
        list: [
            ForeCastWeatherEntry(
                dt: 1713915600,
                main: ForeCastMainWeather(
                    temp: 20.5,
                    feelsLike: 19.8,
                    tempMin: 18.0,
                    tempMax: 22.0,
                    pressure: 1015,
                    seaLevel: 1015,
                    grndLevel: 1000,
                    humidity: 65,
                    tempKf: nil
                ),
                weather: [ForeCastWeather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
                clouds: ForeCastClouds(all: 0),
                wind: ForeCastWind(speed: 5.0, deg: 180, gust: 7.0),
                visibility: 10000,
                pop: 0.1,
                sys: ForeCastSys(pod: "d"),
                dtTxt: "2024-04-23 12:00:00"
            ),
            ForeCastWeatherEntry(
                dt: 1714002000,
                main: ForeCastMainWeather(
                    temp: 22.0,
                    feelsLike: 21.5,
                    tempMin: 19.0,
                    tempMax: 24.0,
                    pressure: 1013,
                    seaLevel: 1013,
                    grndLevel: 999,
                    humidity: 60,
                    tempKf: nil
                ),
                weather: [ForeCastWeather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")],
                clouds: ForeCastClouds(all: 20),
                wind: ForeCastWind(speed: 4.5, deg: 190, gust: 6.5),
                visibility: 10000,
                pop: 0.2,
                sys: ForeCastSys(pod: "d"),
                dtTxt: "2024-04-24 12:00:00"
            ),
            ForeCastWeatherEntry(
                dt: 1714088400,
                main: ForeCastMainWeather(
                    temp: 18.5,
                    feelsLike: 17.9,
                    tempMin: 16.0,
                    tempMax: 20.0,
                    pressure: 1010,
                    seaLevel: 1010,
                    grndLevel: 995,
                    humidity: 70,
                    tempKf: nil
                ),
                weather: [ForeCastWeather(id: 802, main: "Clouds", description: "scattered clouds", icon: "03d")],
                clouds: ForeCastClouds(all: 40),
                wind: ForeCastWind(speed: 3.8, deg: 170, gust: 5.2),
                visibility: 10000,
                pop: 0.3,
                sys: ForeCastSys(pod: "d"),
                dtTxt: "2024-04-25 12:00:00"
            ),
            ForeCastWeatherEntry(
                dt: 1714174800,
                main: ForeCastMainWeather(
                    temp: 16.0,
                    feelsLike: 15.5,
                    tempMin: 14.0,
                    tempMax: 18.0,
                    pressure: 1008,
                    seaLevel: 1008,
                    grndLevel: 990,
                    humidity: 75,
                    tempKf: nil
                ),
                weather: [ForeCastWeather(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")],
                clouds: ForeCastClouds(all: 60),
                wind: ForeCastWind(speed: 4.0, deg: 150, gust: 5.8),
                visibility: 10000,
                pop: 0.4,
                sys: ForeCastSys(pod: "d"),
                dtTxt: "2024-04-26 12:00:00"
            ),
            ForeCastWeatherEntry(
                dt: 1714261200,
                main: ForeCastMainWeather(
                    temp: 14.5,
                    feelsLike: 14.0,
                    tempMin: 12.0,
                    tempMax: 16.0,
                    pressure: 1005,
                    seaLevel: 1005,
                    grndLevel: 985,
                    humidity: 80,
                    tempKf: nil
                ),
                weather: [ForeCastWeather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04d")],
                clouds: ForeCastClouds(all: 90),
                wind: ForeCastWind(speed: 3.5, deg: 140, gust: 4.5),
                visibility: 10000,
                pop: 0.5,
                sys: ForeCastSys(pod: "d"),
                dtTxt: "2024-04-27 12:00:00"
            )
        ],
        city: ForeCastCity(
            id: 123456,
            name: "Sample City",
            coord: ForeCastCoord(lat: 40.7128, lon: -74.0060),
            country: "US",
            population: 8000000,
            timezone: -18000,
            sunrise: 1713889200,
            sunset: 1713936000
        )
    )
}
