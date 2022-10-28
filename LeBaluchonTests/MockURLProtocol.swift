//
//  MockURLProtocol.swift
//  LeBaluchonTests
//
//  Created by laz on 24/10/2022.
//

import Foundation

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
        } catch  {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}


class MockCurrencyFailedCallbackIfError: MockURLProtocol {
    override func startLoading() {
        MockCurrencyFailedCallbackIfError.requestHandler = { request in
            return (ResponseDataFake.responseNok, nil)
        }
        super.startLoading()
    }
}

class MockCurrencyFailedCallbackIfNoData: MockURLProtocol {
    override func startLoading() {
        MockCurrencyFailedCallbackIfNoData.requestHandler = { request in
            return (ResponseDataFake.responseOk, nil)
        }
        super.startLoading()
    }
}


class MockCurrencyFailedCallbackIfDecodeError: MockURLProtocol {
    override func startLoading() {
        MockCurrencyFailedCallbackIfDecodeError.requestHandler = { request in
            return (ResponseDataFake.responseOk, ResponseDataFake.currencyIncorrectData)
        }
        super.startLoading()
    }
}

class MockCurrencySuccess: MockURLProtocol {
    override func startLoading() {
        MockCurrencySuccess.requestHandler = { request in
            return (ResponseDataFake.responseOk, ResponseDataFake.currencyServiceAvailableCurrencies)
        }
        super.startLoading()
    }
}


class MockCurrencyConvertSuccess: MockURLProtocol {
    override func startLoading() {
        MockCurrencyConvertSuccess.requestHandler = { request in
            return (ResponseDataFake.responseOk, ResponseDataFake.currencyServiceConvertData)
        }
        super.startLoading()
    }
}

