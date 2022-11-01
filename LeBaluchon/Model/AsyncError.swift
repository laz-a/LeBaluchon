//
//  AsyncError.swift
//  LeBaluchon
//
//  Created by laz on 31/10/2022.
//

import Foundation

enum AsyncError: String, Error {
    case data = "No data"
    case response = "Response error"
    case decode = "Decode error"
    case json = "Json"
}
