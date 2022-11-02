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
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Currency
    
    static let currencyServiceDataError = """
    {
        "success": false,
        "error": {
            "code": 402,
            "type": "invalid_to_currency",
            "info": "You have entered an invalid to property. [Example: to=GBP]"
        }
    }
    """.data(using: .utf8)!
    
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
    
    static let currencyServiceConvertData = """
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
    
    // MARK: - Translate
    
    static let translateLanguages = """
    {
        "data": {
            "languages": [
                {
                    "language": "en",
                    "name": "English"
                },
                {
                    "language": "fr",
                    "name": "French"
                },
                {
                    "language": "ja",
                    "name": "Japanese"
                }
            ]
        }
    }
    """.data(using: .utf8)!
    
    static let translateTranslation = """
    {
        "data": {
            "translations": [
                {
                    "translatedText": "Good morning !"
                }
            ]
        }
    }
    """.data(using: .utf8)!
}
