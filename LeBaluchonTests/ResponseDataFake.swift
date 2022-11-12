//
//  ResponseDataFake.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import Foundation

class ResponseDataFake {
    // Success response
    static let responseOk = HTTPURLResponse(url: URL(string: "http://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!

    // Error response
    static let responseNok = HTTPURLResponse(url: URL(string: "http://openclassrooms.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!

    // Custom error
    class FakeError: Error {}
    static let error = FakeError()

    // Incorrect data
    static let incorrectData = "erreur".data(using: .utf8)!

// MARK: - Currency
    // Error json response
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

    // Correct symbols json response
    static let currencyServiceAvailableCurrenciesData = """
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

    // Correct conversion json response
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
    // Correct languages json response
    static let translateServiceLanguagesData = """
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

    // Correct translation json response
    static let translateServiceTranslationData = """
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

// MARK: - Weather
    // Correct weather json response
    static var weatherServiceData: Data? {
        let bundle = Bundle(for: ResponseDataFake.self)
        // Read json from Weather.json
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        if let data = try? Data(contentsOf: url!) {
            return data
        }
        return nil
    }
}
