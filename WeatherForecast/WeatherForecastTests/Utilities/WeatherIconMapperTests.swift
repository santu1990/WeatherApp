//
//  WeatherIconMapperTests.swift
//  WeatherForecastTests
//
//  Created by Santosh Singh on 20/03/25.
//

import XCTest
@testable import WeatherForecast

class WeatherIconMapperTests: XCTestCase {

    func testValidWeatherIcons() {
        let iconMapping: [String: String] = [
            "01d": "sun.max.fill",
            "01n": "sun.max.fill",
            "02d": "cloud.sun.fill",
            "02n": "cloud.sun.fill",
            "03d": "cloud.fill",
            "03n": "cloud.fill",
            "04d": "smoke.fill",
            "04n": "smoke.fill",
            "09d": "cloud.rain.fill",
            "09n": "cloud.rain.fill",
            "10d": "cloud.sun.rain.fill",
            "10n": "cloud.moon.rain.fill",
            "11d": "cloud.bolt.fill",
            "11n": "cloud.bolt.fill",
            "13d": "snow",
            "13n": "snow",
            "50d": "cloud.fog.fill",
            "50n": "cloud.fog.fill"
        ]

        for (icon, expectedSymbol) in iconMapping {
            let result = WeatherIconMapper.iconName(for: icon)
            XCTAssertEqual(result, expectedSymbol, "Expected \(expectedSymbol) but got \(result) for icon: \(icon)")
        }
    }

    func testUnknownIconsReturnDefault() {
        let unknownIcons = ["99d", "abc", "random", "sunny", "", "123"]

        for icon in unknownIcons {
            let result = WeatherIconMapper.iconName(for: icon)
            XCTAssertEqual(result, "questionmark",
                           "Expected 'questionmark' but got \(result) for unknown icon: \(icon)")
        }
    }

    /// Tests that case sensitivity does not impact results
    func testCaseSensitivity() {
        XCTAssertEqual(WeatherIconMapper.iconName(for: "01D"), "questionmark", "Function should be case-sensitive")
    }
}
