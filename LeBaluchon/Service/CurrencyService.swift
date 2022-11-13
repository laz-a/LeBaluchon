//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

class CurrencyService {
    // Define singleton
    static var shared = CurrencyService()
    private init() {}

    private static let url = "https://api.apilayer.com/fixer"
    private static let apiKey = ApiKey.fixer

    private var task: URLSessionDataTask?
    private var session = URLSession.shared

    // Unit test custom init
    init(session: URLSession) {
        self.session = session
    }

    // Get list of available currencies
    func getAvailableCurrencies(callback: @escaping(() throws -> [CurrencySymbols.Symbol]) -> Void) {
        let urlSymbols = URL(string: "\(CurrencyService.url)/symbols")!

        // Build request
        var requestSymbols = URLRequest(url: urlSymbols)
        requestSymbols.addValue(CurrencyService.apiKey, forHTTPHeaderField: "apikey")

        // Cancel in progress task if exist
        task?.cancel()

        // Configure task
        task = session.dataTask(with: requestSymbols) { data, response, error in
            DispatchQueue.main.async {
                // Throw error if status code error
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }

                // Throw error if data is empty
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }

                // Throw error if response is an error message
                if let symbolsError = try? JSONDecoder().decode(CurrencyError.self, from: data) {
                    print("\(symbolsError.error.info)")
                    callback({ throw AsyncError.json })
                    return
                }

                // Throw error if decode error
                guard let symbols = try? JSONDecoder().decode(CurrencySymbols.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }

                // Return result if success
                callback({ return symbols.symbols })
            }
        }

        // Perform request
        task?.resume()
    }

    // Get conversion rate for source/target currency
    func getConversionRate(from: String, to: String, callback: @escaping(() throws -> (ConversionRate)) -> Void) {
        var urlConversion = URLComponents(string: "\(CurrencyService.url)/convert")!
        // Set query parameters
        urlConversion.queryItems = [URLQueryItem(name: "from", value: from),
                                    URLQueryItem(name: "to", value: to),
                                    URLQueryItem(name: "amount", value: "1")]

        // Build resquest
        var requestConvert = URLRequest(url: urlConversion.url!)
        requestConvert.addValue(CurrencyService.apiKey, forHTTPHeaderField: "apikey")

        // Cancel in progress task if exist
        task?.cancel()

        // Configure task
        task = session.dataTask(with: requestConvert) { data, response, error in
            DispatchQueue.main.async {
                // Return if task is canceled by user
                guard response != nil else {
                    return
                }

                // Throw error if status code error
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }

                // Throw error if data is empty
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }

                // Throw error if response is an error message
                if let conversionError = try? JSONDecoder().decode(CurrencyError.self, from: data) {
                    print("\(conversionError.error.info)")
                    callback({ throw AsyncError.json })
                    return
                }

                // Throw error if decode error
                guard let conversionRate = try? JSONDecoder().decode(ConversionRate.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }

                // Return resut if success
                callback({ return conversionRate })
            }
        }
        // Perform request
        task?.resume()
    }
}
