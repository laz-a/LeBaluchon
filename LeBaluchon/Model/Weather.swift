//
//  Weather.swift
//  LeBaluchon
//
//  Created by laz on 01/11/2022.
//

import Foundation
import UIKit
import CoreLocation

// Weather structure
struct Weather: Decodable {
    // Current weather structure
    struct Current: Decodable {
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        let weather: [WeatherDetail]
    }

    // Temp structue
    struct Temp: Decodable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

    // Feels like structure
    struct FeelsLike: Decodable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

    // Daily weather structure
    struct Daily: Decodable {
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let moonrise: Int
        let moonset: Int
        let moon_phase: Double
        let temp: Temp
        let feels_like: FeelsLike
        let pressure: Double
        let humidity: Double
        let dew_point: Double
        let wind_speed: Double
        let wind_deg: Double
        let wind_gust: Double
        let weather: [WeatherDetail]
        let clouds: Int?
        let pop: Double?
        let rain: Double?
        let snow: Double?
        let uvi: Double
    }

    // Weather detail structure
    struct WeatherDetail: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String

        enum RootKeys: String, CodingKey {
            case id, main, description, icon
        }

        // Decode json
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKeys.self)

            id = try container.decode(Int.self, forKey: .id)
            main = try container.decode(String.self, forKey: .main)
            description = try container.decode(String.self, forKey: .description)

            let code = try container.decode(String.self, forKey: .icon)

            // Weather icon relative to API weather code
            switch code {
            case "01d": icon = "sun.max"
            case "01n": icon = "moon"
            case "02d": icon = "cloud.sun"
            case "02n": icon = "cloud.moon"
            case "03d": icon = "smoke"
            case "03n": icon = "smoke.fill"
            case "04d": icon = "cloud.fill"
            case "04n": icon = "cloud.fill"
            case "09d": icon = "cloud.heavyrain"
            case "09n": icon = "cloud.heavyrain.fill"
            case "10d": icon = "cloud.sun.rain"
            case "10n": icon = "cloud.moon.rain"
            case "11d": icon = "cloud.bolt"
            case "11n": icon = "cloud.bolt.fill"
            case "13d": icon = "cloud.snow"
            case "13n": icon = "cloud.snow.fill"
            case "50d": icon = "cloud.fog"
            case "50n": icon = "cloud.fog.fill"
            default: icon = "ellipsis"
            }
        }
    }

    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: Current
    let daily: [Daily]
}

// Location structure
struct Location {
    let city: String
    let country: String
    let coordinate: CLLocation
}
