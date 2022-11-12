//
//  WeatherTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 05/11/2022.
//

import XCTest
@testable import LeBaluchon

final class WeatherTestCase: XCTestCase {

    // init CurrencyViewModel with MockURLProtocol
    private func getWeatherViewModel(_ mock: AnyClass) -> WeatherViewModel {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [mock]
        let urlSession = URLSession(configuration: configuration)
        return WeatherViewModel(session: urlSession)
    }

    func testGetWeatherForCoordinateShouldPostFailedCallbackIfError() async {
        // Given
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfError.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForCoordinateShouldPostFailedCallbackIfNoData() async {
        // Given
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfNoData.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForCoordinateShouldPostFailedCallbackIfDecodeError() async {
        // Given
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfDecodeError.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForLocationShouldPostFailedCallbackIfDecodeError() async {
        // Given
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfDecodeError.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(location: "Paris") { getWeather in
            do {
                _ = try getWeather()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForLocationShouldPostFailedCallbackIfLocationError() async {
        // Given
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfError.self)

        // When
        weatherModel.getWeatherForLocation(location: "hjdfbjkfhbjhf") { getWeather in
            do {
                _ = try getWeather()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.location)
            }
        }
    }

    func testGetWeatherForLocationShouldPostFailedCallbackIfCoordinateError() async {
        // Given
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfError.self)

        // When
        weatherModel.getWeatherForLocation(latitude: 222.12, longitude: 333.13) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.location)
            }
        }
    }

    func testGetWeatherForCoordinateShouldPostSuccess() async {
        // Given
        let weatherModel = getWeatherViewModel(MockWeatherSuccess.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            let locationWeather = try? getWeather()
            // Then
            XCTAssertEqual(locationWeather?.location.city, "Paris")
            XCTAssertEqual(locationWeather?.weather.current.temp, 11.94)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForCoordinateAdministrativeAreaShouldPostSuccess() async {
        // Given
        let weatherModel = getWeatherViewModel(MockWeatherSuccess.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(latitude: 35.65, longitude: 139.84) { getWeather in
            let locationWeather = try? getWeather()
            // Then
            XCTAssertEqual(locationWeather?.location.city, "Tokyo")
            XCTAssertEqual(locationWeather?.weather.current.temp, 11.94)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForLocationShouldPostSuccess() async {
        // Given
        let weatherModel = getWeatherViewModel(MockWeatherSuccess.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(location: "Paris") { getWeather in
            let locationWeather = try? getWeather()
            // Then
            XCTAssertEqual(locationWeather?.location.city, "Paris")
            XCTAssertEqual(locationWeather?.weather.current.temp, 11.94)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetWeatherForLocationAdministrativeAreaShouldPostSuccess() async {
        // Given
        let weatherModel = getWeatherViewModel(MockWeatherSuccess.self)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherModel.getWeatherForLocation(location: "Tokyo") { getWeather in
            let locationWeather = try? getWeather()
            // Then
            XCTAssertEqual(locationWeather?.location.city, "Tokyo")
            XCTAssertEqual(locationWeather?.weather.current.temp, 11.94)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
