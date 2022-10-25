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
    
    func getSymbols(completionHandler: @escaping(() throws -> ()) -> ()) {
        currencyService.getAvailableCurrencies { symbols in
            do {
                self.symbols = try symbols()
                completionHandler({})
            } catch  {
                completionHandler({ throw error })
            }
        }
    }
}
