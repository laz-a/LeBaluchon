//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

class CurrencyService {
    static var shared = CurrencyService()
    private init() {}

    private static let apiKey = ApiKey.fixer
    
    private static var from = "EUR"
    private static var to = "USD"

    private static let urlSymbols = URL(string: "https://api.apilayer.com/fixer/symbols")!
    private static var urlConversion: URL {
        return URL(string: "https://api.apilayer.com/fixer/convert?from=\(CurrencyService.from)&to=\(CurrencyService.to)&amount=1")!
    }

    private var task: URLSessionDataTask?
    private var session = URLSession.shared

    private var requestSymbols: URLRequest {
        var request = URLRequest(url: CurrencyService.urlSymbols)
        request.httpMethod = "GET"
        request.addValue(CurrencyService.apiKey, forHTTPHeaderField: "apikey")
        return request
    }

    private var requestConvert: URLRequest {
        var request = URLRequest(url: CurrencyService.urlConversion)
        request.httpMethod = "GET"
        request.addValue(CurrencyService.apiKey, forHTTPHeaderField: "apikey")
        return request
    }
    
    enum AsyncError: Error {
        case data
        case response
        case decode
    }
    
    init(session: URLSession) {
        self.session = session
    }

    func getAvailableCurrencies(callback: @escaping(() throws -> [String: String]) -> Void) {
        task?.cancel()
        task = session.dataTask(with: requestSymbols) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }
                guard let symbols = try? JSONDecoder().decode(CurrencySymbols.self, from: data) else {
                    print(response.statusCode)
                    callback({ throw AsyncError.decode })
                    return
                }

                callback({ return symbols.symbols })
            }
        }
        task?.resume()
    }

    func getConversionRate(from: String, to: String, callback: @escaping(() throws -> (ConversionRate)) -> Void) {
        
        CurrencyService.from = from
        CurrencyService.to = to
        
        task?.cancel()
        task = session.dataTask(with: requestConvert) { data, response, error in
            guard let data = data, error == nil else {
                callback({ throw AsyncError.data })
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback({ throw AsyncError.response })
                return
            }
            guard let conversionRate = try? JSONDecoder().decode(ConversionRate.self, from: data) else {
                print(response.statusCode)
                callback({ throw AsyncError.decode })
                return
            }
            
            
//guard let conversionError = try? JSONDecoder().decode(CurrencyError.self, from: data) else {
//                print(response.statusCode)
//                print("guard let conversionError = try? JSONDecoder().decode(ConversionError.self, from: data) else")
//                callback({ throw AsyncError.json })
//                return
//}

            callback({ return conversionRate })
        }
        task?.resume()
    }
}
