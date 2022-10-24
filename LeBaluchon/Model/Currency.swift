//
//  Currency.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import Foundation

struct CurrencySymbols: Decodable {
    let success: Bool
    let symbols: [String: String]
}

struct ConversionRate: Decodable, Equatable, Hashable {

    enum RootKeys: String, CodingKey {
        case success, query, info, date, result
    }

    enum QueryKeys: String, CodingKey {
        case from, to, amount
    }

    enum InfoKeys: String, CodingKey {
        case timestamp, rate
    }
    
    let from: String
    let to: String
    let rate: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let queryContainer = try container.nestedContainer(keyedBy: QueryKeys.self, forKey: .query)
        from = try queryContainer.decode(String.self, forKey: .from)
        to = try queryContainer.decode(String.self, forKey: .to)
        
        let rateContainer = try container.nestedContainer(keyedBy: InfoKeys.self, forKey: .info)
        rate = try rateContainer.decode(Double.self, forKey: .rate)
    }
}

struct CurrencyError: Decodable {
    let success: Bool
    let error: ErrorConversion
    
    struct ErrorConversion: Decodable {
        let code: Int
        let type: String
        let info: String
    }
}
