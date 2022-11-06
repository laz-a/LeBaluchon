//
//  WeatherTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 05/11/2022.
//

import XCTest
@testable import LeBaluchon

final class WeatherTestCase: XCTestCase {

    private func getWeatherViewModel(_ mock: AnyClass) -> WeatherViewModel {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [mock]
        let urlSession = URLSession(configuration: configuration)
        return WeatherViewModel(session: urlSession)
    }

    func testGetWeatherForCoordinateShouldPostFailedCallbackIfError() async {
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherForCoordinateShouldPostFailedCallbackIfNoData() async {
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherForCoordinateShouldPostFailedCallbackIfDecodeError() async {
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherForLocationShouldPostFailedCallbackIfDecodeError() async {
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherModel.getWeatherForLocation(location: "Paris") { getWeather in
            do {
                _ = try getWeather()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherForLocationShouldPostFailedCallbackIfLocationError() async {
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfError.self)

        weatherModel.getWeatherForLocation(location: "hjdfbjkfhbjhf") { getWeather in
            do {
                _ = try getWeather()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.location)
            }
        }
    }

    func testGetWeatherForLocationShouldPostFailedCallbackIfCoordinateError() async {
        let weatherModel = getWeatherViewModel(MockFailedCallbackIfError.self)

        weatherModel.getWeatherForLocation(latitude: 222.12, longitude: 333.13) { getWeather in
            do {
                _ = try getWeather()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.location)
            }
        }
    }

    func testGetWeatherForCoordinateShouldPostSuccess() async {
        let weatherModel = getWeatherViewModel(MockWeatherSuccess.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherModel.getWeatherForLocation(latitude: 48.85, longitude: 2.35) { getWeather in
            let locationWeather = try? getWeather()

            XCTAssertEqual(locationWeather?.location.city, "Paris")
            XCTAssertEqual(locationWeather?.weather.current.temp, 11.94)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherForLocationShouldPostSuccess() async {
        let weatherModel = getWeatherViewModel(MockWeatherSuccess.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        weatherModel.getWeatherForLocation(location: "Paris") { getWeather in
            let locationWeather = try? getWeather()

            XCTAssertEqual(locationWeather?.location.city, "Paris")
            XCTAssertEqual(locationWeather?.weather.current.temp, 11.94)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
