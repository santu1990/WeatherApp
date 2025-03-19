//
//  LocationService.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import Combine
import MapKit
import CoreLocation

class LocationService: NSObject, ObservableObject {
    @Published var searchResults: [LocationResult] = []
    @Published var currentLocation: LocationResult?

    private var searchCompleter = MKLocalSearchCompleter()
    private var locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var searchSubject = PassthroughSubject<String, Never>() // Debounced search

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Debounce search requests
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchCompleter.queryFragment = query
            }
            .store(in: &cancellables)
    }

    func getLocations(query: String, completion: @escaping ([LocationResult]) -> Void) {
        if query.isEmpty {
            completion([])
            return
        }
        searchSubject.send(query) // Send query to debounced pipeline

        // Capture completion handler to call after fetching location details
        let completionHandler: ([LocationResult]) -> Void = { results in
            DispatchQueue.main.async {
                self.searchResults = results
                completion(results)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completionHandler(self.searchResults)
        }
    }

    private func fetchLocationDetails(for query: String, completion: @escaping (LocationResult?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response, let firstResult = response.mapItems.first,
                  let name = firstResult.placemark.locality ?? firstResult.placemark.name,
                  let coordinate = firstResult.placemark.location?.coordinate else {
                completion(nil)
                return
            }
            completion(LocationResult(title: name, latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
    }

    // MARK: - Fetch Current Location Using CoreLocation
    func requestCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Reverse Geocoding to Get City Name
    private func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            completion(placemark.locality ?? placemark.name)
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCityName(from: location) { [weak self] cityName in
            if let cityName = cityName {
                self?.currentLocation = LocationResult(title: cityName,
                                                       latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude)
            }
        }
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("locationManager didFailWithError: \(error)")
    }
}

extension LocationService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let searchGroup = DispatchGroup()
        var locationResults: [LocationResult] = []
        var seenLocations = Set<String>() // To keep track of unique locations

        for completionResult in completer.results.prefix(5) { // Limit results to avoid API throttling
            searchGroup.enter()
            fetchLocationDetails(for: completionResult.title) { result in
                if let result = result {
                    // Create a unique identifier for each result (latitude, longitude combination)
                    let locationKey = "\(result.latitude),\(result.longitude)"

                    // Check if we've already seen this location
                    if !seenLocations.contains(locationKey) {
                        seenLocations.insert(locationKey)
                        locationResults.append(result) // Add only unique locations
                    }
                }
                searchGroup.leave()
            }
        }

        searchGroup.notify(queue: .main) {
            self.searchResults = locationResults
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search error: \(error.localizedDescription)")
    }
}
