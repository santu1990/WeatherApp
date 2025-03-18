//
//  SearchLocationUseCaseTests.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 18/03/25.
//


import XCTest
import Combine
@testable import WeatherForecast

class MockLocationRepository: LocationRepositoryProtocol {
    var fetchLocationsCalled = false
    var mockLocationResults: [LocationResult] = []

    func fetchLocations(query: String, completion: @escaping ([LocationResult]) -> Void) {
        fetchLocationsCalled = true
        completion(mockLocationResults)
    }
}


class SearchLocationUseCaseTests: XCTestCase {
    var useCase: SearchLocationUseCaseProtocol!
    var mockRepository: MockLocationRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockLocationRepository()  // Corrected type
        useCase = SearchLocationUseCase(repository: mockRepository)  // Pass mock repository
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func testSearchLocationReturnsResults() {
        // Given
        let mockResults = [
            LocationResult(title: "New York", latitude: 40.7128, longitude: -74.0060),
            LocationResult(title: "Los Angeles", latitude: 34.0522, longitude: -118.2437)
        ]
        mockRepository.mockLocationResults = mockResults

        let expectation = XCTestExpectation(description: "Search location results are returned")

        // When
        useCase.searchLocation(query: "New") { results in
            // Then
            XCTAssertTrue(self.mockRepository.fetchLocationsCalled, "fetchLocations was not called")
            XCTAssertEqual(results.count, 2, "Expected 2 location results")
            XCTAssertEqual(results.first?.title, "New York", "First location title should be 'New York'")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchLocationReturnsEmptyResultsWhenQueryIsEmpty() {
        // Given
        mockRepository.mockLocationResults = []

        let expectation = XCTestExpectation(description: "No results returned when query is empty")

        // When
        useCase.searchLocation(query: "") { results in
            // Then
            XCTAssertTrue(self.mockRepository.fetchLocationsCalled, "fetchLocations was not called")
            XCTAssertEqual(results.count, 0, "Expected no location results")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

