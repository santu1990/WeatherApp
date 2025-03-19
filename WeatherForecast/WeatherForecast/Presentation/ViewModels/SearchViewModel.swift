//
//  SearchViewModel.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var locationQuery: String = ""
    @Published var searchResults: [LocationResult] = []
    @Published var selectedLatitude: Double?
    @Published var selectedLongitude: Double?

    private let searchUseCase: SearchLocationUseCase
    private var cancellables = Set<AnyCancellable>()
    private let searchDebounce = PassthroughSubject<String, Never>()

    init(searchUseCase: SearchLocationUseCase) {
        self.searchUseCase = searchUseCase

        searchDebounce
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    func updateQuery(_ query: String) {
        locationQuery = query
        searchDebounce.send(query)
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        searchUseCase.searchLocation(query: query) { [weak self] results in
            DispatchQueue.main.async {
                self?.searchResults = results
            }
        }
    }

    func selectLocation(_ location: LocationResult) {
        selectedLatitude = location.latitude
        selectedLongitude = location.longitude
        locationQuery = location.title
        searchResults = []
    }
}
