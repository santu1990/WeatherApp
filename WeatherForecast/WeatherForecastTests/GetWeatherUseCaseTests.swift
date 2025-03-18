//
//  GetWeatherUseCaseTests.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//


import XCTest
import Combine
@testable import WeatherForecast

// Create the mock class for WeatherRepositoryProtocol
class MockWeatherRepository: WeatherRepositoryProtocol {
    var fetchCalled = false

    func fetch<T>(endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        fetchCalled = true

        // Mock data to return for WeatherData
        let mockResponse = WeatherResponseStub.mockWeatherResponse
        // Safely cast the mock response to the expected type T
        guard let response = mockResponse as? T else {
            return Fail(error: NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to cast mock response to type T"]))
                .eraseToAnyPublisher()
        }
        // Return the mock response as a publisher
        return Just(response)
            .setFailureType(to: Error.self) // set the failure type to `Error`
            .eraseToAnyPublisher() // erase to `AnyPublisher` for flexibility
    }
}

class WeatherRepositoryTests: XCTestCase {
    var repository: MockWeatherRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        repository = MockWeatherRepository()
    }

    override func tearDown() {
        // Clean up any resources after each test
        repository = nil
        cancellables = []
        super.tearDown()
    }
    
    func testFetchWeather() {
        // Create a test expectation
        let expectation = self.expectation(description: "Weather fetch should succeed")
        let endPoint = APIEndpoint.currentWeather(lat: 28.436225, lon: 77.324765)
        // Call the fetch method
        repository.fetch(endpoint: endPoint, responseType: WeatherResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTFail("Expected success but got failure: \(error.localizedDescription)")
                }
            }, receiveValue: { weatherData in
                XCTAssertEqual(weatherData.name, "Delhi")
                XCTAssertEqual(weatherData.weather.first?.main, "Clear")
                XCTAssertEqual(weatherData.main.temp, 298.15)

                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }
}

