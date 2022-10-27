//
//  CurrencyTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import XCTest
@testable import LeBaluchon

final class CurrencyTestCase: XCTestCase {
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfError() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockCurrencyFailedCallbackIfError.self]
        let urlSession = URLSession(configuration: configuration)

        let currencyModel = CurrencyModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { success in
            
//            XCTAssertThrowsError<#_#>(let trez = try success(), "Error incorrect expression") { error in
//                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
//            }
            
            do {
                try success()
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

        let currencyModel = CurrencyModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { success in
            do {
                try success()
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

        let currencyModel = CurrencyModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { success in
            do {
                try success()
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

        let currencyModel = CurrencyModel(session: urlSession)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currencyModel.getSymbols { success in
            do {
                try success()
                debugPrint("XCTAssertEqual :: Success")
                XCTAssertEqual(currencyModel.availableCurrencies, ["Bhutanese Ngultrum", "Bitcoin", "Botswanan Pula", "Euro", "United States Dollar"])
            } catch {
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }

}
