//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by laz on 01/11/2022.
//

import Foundation

class WeatherService {
    static var shared = WeatherService()
    private init() {}

    private static let url = "https://api.openweathermap.org/data/3.0/onecall"
    private static let apiKey = ApiKey.openWeatherMap
    
    private var task: URLSessionDataTask?
    private var session = URLSession.shared
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getWeather(latitude: Double, longitude: Double, callback: @escaping(() throws -> Weather) -> Void) {
        let urlWeather = URL(string: "\(WeatherService.url)")!
        var requestWeather = URLRequest(url: urlWeather)
        let queryItems = [URLQueryItem(name: "appid", value: WeatherService.apiKey),
                          URLQueryItem(name: "lat", value: String(latitude)),
                          URLQueryItem(name: "lon", value: String(longitude)),
                          URLQueryItem(name: "units", value: "metric"),
                          URLQueryItem(name: "exclude", value: "minutely,hourly,alerts")]

        requestWeather.url?.append(queryItems: queryItems)

        task?.cancel()
        task = session.dataTask(with: requestWeather) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback({ throw AsyncError.response })
                    return
                }
                guard let data = data, !data.isEmpty, error == nil else {
                    callback({ throw AsyncError.data })
                    return
                }
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback({ throw AsyncError.decode })
                    return
                }
                callback({ return weather })
            }
        }
        task?.resume()
    }
}
