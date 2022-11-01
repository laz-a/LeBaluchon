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
            
//            XCTAssertThrowsError(let trez = try getSymbols(), "Error incorrect expression") { error in
//                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
//            }
            
            do {
                let _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfNoData() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                let _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDecodeError() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                let _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDataError() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyFailedCallbackIfDataError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                let _ = try getSymbols()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.json)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostSuccess() async {
        let currencyModel = getCurrencyViewModel(MockCurrencySuccess.self)
        XCTAssertNil(currencyModel.symbols)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfError() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                let _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfNoData() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfNoData.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                let _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.data)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDataError() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyFailedCallbackIfDataError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EURo", to: "USD", amount: 1) { getResult in
            do {
                let _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.json)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDecodeError() async {
        let currencyModel = getCurrencyViewModel(MockFailedCallbackIfDecodeError.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            do {
                let _ = try getResult()
            } catch {
                XCTAssertEqual(error as? AsyncError, AsyncError.decode)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostSuccess() async {
        let currencyModel = getCurrencyViewModel(MockCurrencyConvertSuccess.self)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { getResult in
            let amount = try? getResult()
            XCTAssertEqual(amount, 0.987523)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
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
        wait(for: [expectation], timeout: 0.1)
    }
}
