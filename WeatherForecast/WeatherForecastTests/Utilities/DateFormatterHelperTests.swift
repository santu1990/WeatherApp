//
//  DateFormatterHelperTests.swift
//  WeatherForecast
//
//  Created by Santosh Singh on 20/03/25.
//

import XCTest
@testable import WeatherForecast

class DateFormatterHelperTests: XCTestCase {
    
    func testFormatDate() {
        // Given: A fixed timestamp (e.g., July 20, 2024)
        let timestamp: TimeInterval = 1721433600 // Corresponds to 2024-07-20 00:00:00 UTC
        
        // When: Formatting the date
        let formattedDate = DateFormatterHelper.formatDate(timestamp)
        
        // Then: The output should match the expected medium-style format
        let expectedDate = formattedDateForLocale(timestamp)
        
        XCTAssertEqual(formattedDate, expectedDate, "Expected \(expectedDate) but got \(formattedDate)")
    }
    
    private func formattedDateForLocale(_ timestamp: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
