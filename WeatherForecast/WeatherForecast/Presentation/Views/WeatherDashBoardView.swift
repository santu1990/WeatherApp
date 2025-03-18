//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 17/03/25.
//

import SwiftUI
import Combine

struct WeatherDashBoardView: View {
    private let locationService: LocationService
    @StateObject var weatherViewModel: WeatherViewModel
    @StateObject var forecastViewModel: ForecastViewModel
    @StateObject var searchViewModel = SearchViewModel(searchUseCase: SearchLocationUseCase())

    init() {
        let locationService = LocationService()
        self.locationService = locationService

        let useCase = GetWeatherUseCase(repository: WeatherRepository(service: WeatherService()))

        _weatherViewModel = StateObject(wrappedValue: WeatherViewModel(locationService: locationService, useCase: useCase))
        _forecastViewModel = StateObject(wrappedValue: ForecastViewModel(locationService: locationService, useCase: useCase))
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        TextField("Search for a location", text: $searchViewModel.locationQuery)
                            .padding(.horizontal)
                            .padding(5)
                            .frame(height: 40)
                            .background(Color.white) // Background color
                            .cornerRadius(5) // Rounded corners for better look
                            .shadow(radius: 3) // Optional: Keeps the shadow effect
                            .onChange(of: searchViewModel.locationQuery) { _, newValue in
                                searchViewModel.updateQuery(newValue)
                            }
                        Spacer()
                    }

                    ScrollView {
                        VStack(spacing: 0) {
                            if let weather = weatherViewModel.weatherData {
                                WeatherCard(weather: weather)
                            }

                            Spacer()

                            FiveDayForecastView(forecastVM: forecastViewModel)
                        }
                    }
                }

                // Search List - Only visible when there are search results
                if !searchViewModel.searchResults.isEmpty {
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(searchViewModel.searchResults, id: \.id) { result in
                                    Button(action: {
                                        searchViewModel.selectLocation(result)
                                        if let lat = searchViewModel.selectedLatitude, let lon = searchViewModel.selectedLongitude {
                                            weatherViewModel.fetchWeather(lat: lat, lon: lon)
                                            forecastViewModel.fetchWeatherForeCast(lat: lat, lon: lon)
                                        }

                                        // Clear search list after a slight delay to allow the state change to propagate
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            searchViewModel.searchResults = []
                                            searchViewModel.locationQuery = ""  // Optional: Reset search query to clear the search bar
                                        }
                                    }) {
                                        Text(result.title)
                                            .foregroundColor(.black)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white.opacity(0.5))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxHeight: 300)
                            .background(Color.clear)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 300)  // Set the height for the search list
                        .zIndex(1)  // Ensure the search list appears on top of the content below
                        .transition(.move(edge: .top))  // Add a smooth transition for search list
                    }
                    .padding(.top, 30)
                }
            }
            .navigationTitle("Weather Forecast")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}








