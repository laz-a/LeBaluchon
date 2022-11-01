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
    
    private static let url = "https://api.apilayer.com/fixer"
    private static let apiKey = ApiKey.fixer
    
    private var task: URLSessionDataTask?
    private var session = URLSession.shared
    
    init(session: URLSession) {
        self.session = session
    }

    func getAvailableCurrencies(callback: @escaping(() throws -> [CurrencySymbols.Symbol]) -> Void) {
        let urlSymbols = URL(string: "\(CurrencyService.url)/symbols")!
        var requestSymbols = URLRequest(url: urlSymbols)
        requestSymbols.addValue(CurrencyService.apiKey, forHTTPHeaderField: "apikey")
        
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
                
                if let symbolsError = try? JSONDecoder().decode(CurrencyError.self, from: data) {
                    debugPrint("~~~~~~~~~~~~~~\(symbolsError.error.info)")
                    callback({ throw AsyncError.json })
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
        let urlConversion = URL(string: "\(CurrencyService.url)/convert?from=\(from)&to=\(to)&amount=1")!
        var requestConvert = URLRequest(url: urlConversion)
        requestConvert.addValue(CurrencyService.apiKey, forHTTPHeaderField: "apikey")
        
        task?.cancel()
        task = session.dataTask(with: requestConvert) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }
                                
                if let conversionError = try? JSONDecoder().decode(CurrencyError.self, from: data) {
                    print("\(conversionError.error.info)")
                    callback({ throw AsyncError.json })
                    return
                }
                
                guard let conversionRate = try? JSONDecoder().decode(ConversionRate.self, from: data) else {
                    print(response.statusCode)
                    callback({ throw AsyncError.decode })
                    return
                }
                callback({ return conversionRate })
            }
        }
        task?.resume()
    }
}
