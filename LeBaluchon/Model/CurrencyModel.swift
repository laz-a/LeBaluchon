//
//  CurrencyModel.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

class CurrencyModel {
    // Currency service singleton
    private var currencyService = CurrencyService.shared

    // From/to currency default value
    let defaultFromCurrency = Locale.current.currencyCode ?? "EUR"
    var defaultToCurrency: String {
        return defaultFromCurrency == "EUR" ? "USD" : "EUR"
    }

    // Currencies symbols array
    var symbols = [CurrencySymbols.Symbol]()

    // Conversion rate Set
    private var conversionsRates = Set<ConversionRate>()

    init() {}

    // Init used for unit tests
    init(session: URLSession) {
        currencyService = CurrencyService(session: session)
    }

    // Request currencies symbols from service
    func getSymbols(completionHandler: @escaping(() throws -> ([CurrencySymbols.Symbol])) -> Void) {
        // If symbols is not empty, return symbols
        if !symbols.isEmpty {
            completionHandler({ return symbols })
        } else {
            // Else get currencies from service
            currencyService.getAvailableCurrencies { getSymbols in
                do {
                    // Save requested symbols
                    self.symbols = try getSymbols()
                    completionHandler({ return self.symbols })
                } catch {
                    // Throw error service
                    completionHandler({ throw error })
                }
            }
        }
    }

    // Get conversion rate for from/to currencies
    func getConversion(from: String, to: String, amount: Double, completionHandler: @escaping(() throws -> Double) -> Void) {
        // If conversion rate exist in conversionsRates Set, use saved element
        if let conversionRate = conversionsRates.first(where: { $0.from == from && $0.to == to }) {
            // Return converted value
            completionHandler({ return amount * conversionRate.rate })
        } else {
            // Else ask currency service
            currencyService.getConversionRate(from: from, to: to) { getConversionRate in
                do {
                    let conversionRate = try getConversionRate()
                    // Save element in conversionsRates Set
                    self.conversionsRates.insert(conversionRate)
                    // Return convertes value
                    completionHandler({ return amount * conversionRate.rate })
                } catch {
                    // Throw error service
                    completionHandler({ throw error })
                }
            }
        }
    }
}
