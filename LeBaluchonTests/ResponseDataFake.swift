//
//  ResponseDataFake.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import Foundation

struct ResponseDataFake {
    static let responseOk = HTTPURLResponse(url: URL(string: "http://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    static let responseNok = HTTPURLResponse(url: URL(string: "http://openclassrooms.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
    
    class FakeError: Error {}
    static let error = FakeError()
    
    static let currencyServiceAvailableCurrencies = """
    {
        "success": true,
        "symbols": {
            "BTC": "Bitcoin",
            "BTN": "Bhutanese Ngultrum",
            "BWP": "Botswanan Pula",
            "EUR": "Euro",
            "USD": "United States Dollar",
        }
    }
    """.data(using: .utf8)!
    
    static var currencyServiceConvertData = """
    {
        "success": true,
        "query": {
            "from": "EUR",
            "to": "USD",
            "amount": 1
        },
        "info": {
            "timestamp": 1666640584,
            "rate": 0.987523
        },
        "date": "2022-10-24",
        "result": 0.987523
    }
    """.data(using: .utf8)!
    
    static let currencyIncorrectData = "erreur".data(using: .utf8)!
}
