//
//  CurrencyTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import XCTest
@testable import LeBaluchon

final class CurrencyTestCase: XCTestCase {

    // init CurrencyViewModel with MockURLProtocol
    private func getCurrencyViewModel(_ mock: AnyClass) -> CurrencyViewModel {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [mock]
        let urlSession = URLSession(configuration: configuration)
        return CurrencyViewModel(session: urlSession)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfError() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfNoData() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfNoData.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDecodeError() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfDecodeError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDataError() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockCurrencyFailedCallbackIfDataError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.json)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostSuccess() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockCurrencySuccess.self)
        
        // When
        XCTAssertTrue(currencyModel.symbols.isEmpty)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            // Then
            if let symbols = try? getSymbols() {
                XCTAssertEqual(symbols.map { $0.country }, ["Bhutanese Ngultrum", "Bitcoin", "Botswanan Pula", "Euro", "United States Dollar"])
            }
            currencyModel.getSymbols { getSymbols in
                if let symbols = try? getSymbols() {
                    XCTAssertEqual(symbols.map { $0.country }, ["Bhutanese Ngultrum", "Bitcoin", "Botswanan Pula", "Euro", "United States Dollar"])
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfError() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfNoData() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfNoData.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDataError() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockCurrencyFailedCallbackIfDataError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EURo", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.json)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDecodeError() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfDecodeError.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                // Then
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostSuccess() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockCurrencyConvertSuccess.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            let amount = try? getResult()
            // Then
            XCTAssertEqual(amount, 0.987523)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionFromSetShouldPostSuccess() async {
        // Given
        let currencyModel = getCurrencyViewModel(MockCurrencyConvertSuccess.self)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            let amount = try? getResult()
            // Then
            XCTAssertEqual(amount, 0.987523)
            currencyModel.getConversion(from: "EUR", to: "USD", amount: 2) { getResult in
                let amount = try? getResult()
                XCTAssertEqual(amount, 1.975046)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
