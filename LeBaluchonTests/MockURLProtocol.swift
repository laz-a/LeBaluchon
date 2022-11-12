//
//  MockURLProtocol.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import Foundation

// MockURLProtocol for unit tests
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?) )?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func stopLoading() {}
    override func startLoading() {
         guard let handler = MockURLProtocol.requestHandler else {
            return
        }
        do {
            let (response, data)  = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}

// MARK: - Default

// Custom mock for incorrect status code response
class MockFailedCallbackIfError: MockURLProtocol {
    override func startLoading() {
        MockFailedCallbackIfError.requestHandler = { _ in
            return (ResponseDataFake.responseNok, nil)
        }
        super.startLoading()
    }
}

// Custom mock for empty data
class MockFailedCallbackIfNoData: MockURLProtocol {
    override func startLoading() {
        MockFailedCallbackIfNoData.requestHandler = { _ in
            return (ResponseDataFake.responseOk, nil)
        }
        super.startLoading()
    }
}

// Custom mock for incorrect data
class MockFailedCallbackIfDecodeError: MockURLProtocol {
    override func startLoading() {
        MockFailedCallbackIfDecodeError.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.incorrectData)
        }
        super.startLoading()
    }
}

// MARK: - Currency

// Custom mock for data error
class MockCurrencyFailedCallbackIfDataError: MockURLProtocol {
    override func startLoading() {
        MockCurrencyFailedCallbackIfDataError.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.currencyServiceDataError)
        }
        super.startLoading()
    }
}

// Custom mock for symbols request data
class MockCurrencySuccess: MockURLProtocol {
    override func startLoading() {
        MockCurrencySuccess.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.currencyServiceAvailableCurrenciesData)
        }
        super.startLoading()
    }
}

// Custom mock for conversion request data
class MockCurrencyConvertSuccess: MockURLProtocol {
    override func startLoading() {
        MockCurrencyConvertSuccess.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.currencyServiceConvertData)
        }
        super.startLoading()
    }
}

// MARK: - Translate

// Custom mock for languages request data
class MockTranslateLanguagesSuccess: MockURLProtocol {
    override func startLoading() {
        MockTranslateLanguagesSuccess.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.translateServiceLanguagesData)
        }
        super.startLoading()
    }
}

// Custom mock for translation request data
class MockTranslateTranslationSuccess: MockURLProtocol {
    override func startLoading() {
        MockTranslateTranslationSuccess.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.translateServiceTranslationData)
        }
        super.startLoading()
    }
}

// MARK: - Weather

// Custom mock for weather request data
class MockWeatherSuccess: MockURLProtocol {
    override func startLoading() {
        MockWeatherSuccess.requestHandler = { _ in
            return (ResponseDataFake.responseOk, ResponseDataFake.weatherServiceData)
        }
        super.startLoading()
    }
}
