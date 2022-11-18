//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by laz on 01/11/2022.
//

import Foundation

final class WeatherService {
    // Define singleton
    static var shared = WeatherService()
    private init() {}

    private static let url = ServiceURL.weather
    private static let apiKey = ApiKey.openWeatherMap

    private var task: URLSessionDataTask?
    private var session = URLSession.shared

    // Unit test custom init
    init(session: URLSession) {
        self.session = session
    }

    // Get weather for coordinate : latitude/longitude
    func getWeather(latitude: Double, longitude: Double, callback: @escaping(() throws -> Weather) -> Void) {
        var urlWeather = URLComponents(string: "\(WeatherService.url)")!

        // Set query parameters
        urlWeather.queryItems = [URLQueryItem(name: "appid", value: WeatherService.apiKey),
                                 URLQueryItem(name: "lat", value: String(latitude)),
                                 URLQueryItem(name: "lon", value: String(longitude)),
                                 URLQueryItem(name: "units", value: "metric"),
                                 URLQueryItem(name: "exclude", value: "minutely,hourly,alerts")]

        // Build request
        let requestWeather = URLRequest(url: urlWeather.url!)

        // Cancel in progress task if exist
        task?.cancel()

        // Configure task
        task = session.dataTask(with: requestWeather) { data, response, error in
            DispatchQueue.main.async {
                // Throw error if status code error
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }

                // Throw error if data is empty
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }

                // Throw error if decode error
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }

                // Return result if success
                callback({ return weather })
            }
        }

        // Perform request
        task?.resume()
    }
}
