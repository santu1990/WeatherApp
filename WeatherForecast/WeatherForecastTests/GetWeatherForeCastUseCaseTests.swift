//
//  GetWeatherForeCastUseCaseTests.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//

import XCTest
import Combine
@testable import WeatherForecast

// Create the mock class for WeatherForeCastRepositoryProtocol
class MockWeatherForeCastRepository: WeatherRepositoryProtocol {
    var fetchCalled = false

    func fetch<T>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        fetchCalled = true

        // Mock data to return for WeatherForeCastData
        let mockResponse = WeatherResponseStub.mockForecastData
        // Safely cast the mock response to the expected type T
        guard let response = mockResponse as? T else {
            return Fail(error: NSError(domain: "MockError",
                                       code: 1,
                                       userInfo: [NSLocalizedDescriptionKey: "Failed to cast mock response to type T"]))
                .eraseToAnyPublisher()
        }
        // Return the mock response as a publisher
        return Just(response)
            .setFailureType(to: Error.self) // set the failure type to `Error`
            .eraseToAnyPublisher() // erase to `AnyPublisher` for flexibility
    }
}

class WeatherForeCastRepositoryTests: XCTestCase {
    var repository: MockWeatherForeCastRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        repository = MockWeatherForeCastRepository()
    }

    override func tearDown() {
        // Clean up any resources after each test
        repository = nil
        cancellables = []
        super.tearDown()
    }

    func testFetchWeatherForeCast() {
        // Create a test expectation
        let expectation = self.expectation(description: "Weather fetch should succeed")
        let endPoint = APIEndpoint.forecast(lat: 40.7128, lon: -74.0060)
        // Call the fetch method
        repository.fetch(endpoint: endPoint, responseType: ForeCastWeatherResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTFail("Expected success but got failure: \(error.localizedDescription)")
                }
            }, receiveValue: { weatherData in
                let firstEntryObje = weatherData.list.first!
                // Verify the mock response data
                XCTAssertEqual(weatherData.city.name, "Sample City")
                XCTAssertEqual(firstEntryObje.weather.first?.main, "Clear")
                XCTAssertEqual(firstEntryObje.weather.first?.description, "clear sky")
                XCTAssertEqual(firstEntryObje.main.temp, 20.5)

                // Fulfill the expectation when the response is received
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
    }
}
