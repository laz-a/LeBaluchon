//
//  CurrencyTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import XCTest
@testable import LeBaluchon

final class CurrencyTestCase: XCTestCase {
    
//    private func getUrlSession<T>(mock: T) -> URLSession {
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [T]
//        return URLSession(configuration: configuration)
//    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfError() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfError.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            
//            XCTAssertThrowsError(let trez = try getSymbols(), "Error incorrect expression") { error in
//                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
//            }
            
            do {
                let _ = try getSymbols()
            } catch {
                debugPrint("XCTAssertEqual :: CurrencyService.AsyncError.response")
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
            }
            
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfNoData() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfNoData.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                let _ = try getSymbols()
            } catch {
                debugPrint("XCTAssertEqual :: CurrencyService.AsyncError.data")
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.data)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfDecodeError() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfDecodeError.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            do {
                let _ = try getSymbols()
            } catch {
                debugPrint("XCTAssertEqual :: CurrencyService.AsyncError.decode")
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.decode)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrenciesShouldPostSuccess() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencySuccess.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        XCTAssertNil(currencyModel.symbols)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { getSymbols in
            
            if let symbols = try? getSymbols() {
                XCTAssertEqual(symbols.map { $0.country }, ["Bhutanese Ngultrum", "Bitcoin", "Botswanan Pula", "Euro", "United States Dollar"])
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfError() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfError.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { result in
            
//            XCTAssertThrowsError<#_#>(let trez = try success(), "Error incorrect expression") { error in
//                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
//            }
            
            do {
                let _ = try result()
            } catch {
                debugPrint("XCTAssertEqual :: CurrencyService.AsyncError.response")
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
            }
            
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfNoData() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfNoData.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { result in
            do {
                let _ = try result()
            } catch {
                debugPrint("XCTAssertEqual :: CurrencyService.AsyncError.data")
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.data)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAvailableCurrencyConversionShouldPostFailedCallbackIfDecodeError() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfDecodeError.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { result in
            do {
                let _ = try result()
            } catch {
                debugPrint("XCTAssertEqual :: CurrencyService.AsyncError.decode")
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.decode)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    func testGetAvailableCurrencyConversionShouldPostSuccess() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyConvertSuccess.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { result in
            do {
                let amount = try result()
                debugPrint("XCTAssertEqual :: Success :: \(amount)")
                XCTAssertEqual(amount, 0.987523)
            } catch {
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func testGetAvailableCurrencyConversionFromSetShouldPostSuccess() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyConvertSuccess.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyViewModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getConversion(from: "EUR", to: "USD", amount: 1) { result in
            do {
                let amount = try result()
                XCTAssertEqual(amount, 0.987523)
                
                currencyModel.getConversion(from: "EUR", to: "USD", amount: 2) { result in
                    do {
                        let amount = try result()
                        XCTAssertEqual(amount, 1.975046)
                        
                        
                    } catch {
                    }
                }
                
            } catch {
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }

}
