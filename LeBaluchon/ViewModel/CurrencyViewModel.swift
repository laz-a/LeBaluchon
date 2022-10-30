//
//  CurrencyModel.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

class CurrencyViewModel {
    var symbols: [CurrencySymbols.Symbol]?
    var currencyService = CurrencyService.shared
    
    var conversionsRates = Set<ConversionRate>()
    
    init() {}
    
    init(session: URLSession) {
        currencyService = CurrencyService(session: session)
    }
    
    func getSymbols(completionHandler: @escaping(() throws -> ([CurrencySymbols.Symbol])) -> Void) {
        if let symbols = symbols {
            completionHandler({ return symbols })
        } else {
            currencyService.getAvailableCurrencies { getSymbols in
                do {
                    self.symbols = try getSymbols()
                    completionHandler({ return self.symbols! })
                } catch  {
                    completionHandler({ throw error })
                }
            }
        }
    }
    
    func getConversion(from: String, to: String, amount: Double, completionHandler: @escaping(() throws -> Double) -> Void) {
        if let conversionRate = conversionsRates.first(where: { $0.from == from && $0.to == to }) {
            completionHandler({ return amount * conversionRate.rate })
        } else {
            currencyService.getConversionRate(from: from, to: to) { getConversionRate in
                do {
                    let conversionRate = try getConversionRate()
                    self.conversionsRates.insert(conversionRate)
                    completionHandler({ return amount * conversionRate.rate })
                } catch  {
                    completionHandler({ throw error })
                }
            }
        }
    }
}
