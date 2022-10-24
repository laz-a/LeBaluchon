//
//  CurrencyModel.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

class CurrencyModel {
    var symbols: [String: String]?
    
    var availableCurrencies: [String]? {
        if let symbols = symbols {
            return Array(symbols.values).sorted()
        }
        return nil
    }
    
    var conversionsRates = Set<ConversionRate>()
    
    func getSymbols(completionHandler: @escaping(() throws -> ()) -> Void) {
        CurrencyService.shared.getAvailableCurrencies { symbols in
            do {
                self.symbols = try symbols()
                completionHandler({})
            } catch  {
                completionHandler({ throw error })
            }
        }
    }
}
