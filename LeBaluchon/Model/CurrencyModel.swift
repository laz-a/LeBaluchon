//
//  CurrencyModel.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

class CurrencyModel {
    var symbols: [String: String]?
    var currencyService = CurrencyService.shared
    
    var availableCurrencies: [String]? {
        if let symbols = symbols {
            return Array(symbols.values).sorted()
        }
        return nil
    }
    
    var conversionsRates = Set<ConversionRate>()
    
    init(session: URLSession) {
        currencyService = CurrencyService(session: session)
    }
    
    func getSymbols(completionHandler: @escaping(() throws -> ()) -> Void) {
        currencyService.getAvailableCurrencies { symbols in
            do {
                self.symbols = try symbols()
                completionHandler({})
            } catch  {
                completionHandler({ throw error })
            }
        }
    }
    
    func getConversion(from: String, to: String, amount: Double, completionHandler: @escaping(() throws -> Double) -> Void) {
        if let conversionRate = conversionsRates.first(where: { $0.from == from && $0.to == to }) {
            completionHandler({ return amount * conversionRate.rate })
        } else {
            currencyService.getConversionRate(from: from, to: to) { conversionRate in
                do {
                    let conversionRate = try conversionRate()
                    self.conversionsRates.insert(conversionRate)
                    completionHandler({ return amount * conversionRate.rate })
                } catch  {
                    completionHandler({ throw error })
                }
            }
        }
    }
}
