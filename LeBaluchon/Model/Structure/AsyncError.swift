//
//  AsyncError.swift
//  LeBaluchon
//
//  Created by laz on 31/10/2022.
//

import Foundation

// Custom API error
enum AsyncError: Error {
    case data
    case response
    case decode
    case json
    case location
}

// Define error description
extension AsyncError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .data:
            return NSLocalizedString("Error in request data", comment: "Data error")
        case .response:
            return NSLocalizedString("Invalid API response", comment: "Response error")
        case .decode:
            return NSLocalizedString("Json decoding error", comment: "Decode error")
        case .json:
            return NSLocalizedString("Json format error", comment: "Json error")
        case .location:
            return NSLocalizedString("Location error", comment: "Location error")
        }
    }
}
