//
//  CurrencyTestCase.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import XCTest
@testable import LeBaluchon

final class CurrencyTestCase: XCTestCase {

    var urlSession: URLSession!
    var currencyModel: CurrencyModel!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)

        currencyModel = CurrencyModel(session: urlSession)
    }
    
    func testGetAvailableCurrenciesShouldPostFailedCallbackIfError() {
        
        MockURLProtocol.requestHandler = { request in
            return (ResponseDataFake.responseNok, ResponseDataFake.currencyServiceAvailableCurrencies)
        }
        
        currencyModel.getSymbols { success in
            do {
                try success()
            } catch {
                XCTAssertEqual(error as? CurrencyService.AsyncError, CurrencyService.AsyncError.response)
            }
            
        }
        
//        currencyModel.getSymbols { success in
//            do {
//                try success()
//                debugPrint("currencyModel.getSymbols completionHandler")
//                if let availableCurrencies = self.currencyModel.availableCurrencies {
//                    debugPrint(availableCurrencies)
//                }
//            } catch {
//                debugPrint(error)
//            }
//
//        }
        
    }

}
