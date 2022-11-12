//
//  CurrencyTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import XCTest
@testable import LeBaluchon

final class CurrencyTestCase: XCTestCase {

    private func getCurrencyViewModel(_ mock: AnyClass) -> CurrencyViewModel {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [mock]
        let urlSession = URLSession(configuration: configuration)
        return CurrencyViewModel(session: urlSession)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfError() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfNoData() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDecodeError() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDataError() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyFailedCallbackIfDataError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.json)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrenciesShouldPostSuccess() async {
        let currencyModel = getCurrencyViewModel(MockCurrencySuccess.self)
        XCTAssertTrue(currencyModel.symbols.isEmpty)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
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
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfNoData() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDataError() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyFailedCallbackIfDataError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EURo", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.json)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDecodeError() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionShouldPostSuccess() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyConvertSuccess.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            let amount = try? getResult()
            XCTAssertEqual(amount, 0.987523)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetAvailableCurrencyConversionFromSetShouldPostSuccess() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyConvertSuccess.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            let amount = try? getResult()
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
