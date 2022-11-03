//
//  WeatherViewModel.swift
//  LeBaluchon
//
//  Created by laz on 01/11/2022.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    private var weatherService = WeatherService.shared
    private let geocoder = CLGeocoder()
    
    init() {}
    init(session: URLSession) {
        weatherService = WeatherService(session: session)
    }
    
    func getWeather(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> Weather) -> Void) {
        weatherService.getWeather(latitude: latitude, longitude: longitude) { getWeather in
            do {
                let weather = try getWeather()
                completionHandler({ return weather })
            } catch  {
                completionHandler({ throw error })
            }
        }
    }
    
    func getWeather(location: String, completionHandler: @escaping(() throws -> (location: Location, weather: Weather)) -> Void) {
        print("getWeather(location: \(location))")
        getLocation(from: location) { getLocation in
            do {
                print("getLatLon")
                let location = try getLocation()
                self.getWeather(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude) { getWeather in
                    do {
                        let weather = try getWeather()
                        completionHandler({ return (location: location, weather: weather) })
                    } catch  {
                        completionHandler({ throw error })
                    }
                }
                print(location)
            } catch {
                print(error)
            }
        }
    }
    
    func getLocation(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> Location) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, let city = placemark.locality, let country = placemark.country else {
                return
            }
            DispatchQueue.main.async {
                let location = Location(city: city, country: country, coordinate: location)
                completionHandler({ return location })
            }
        }
    }
    
    private func getLocation(from city: String, completionHandler: @escaping(() throws -> Location) -> Void) {
        geocoder.geocodeAddressString(city) { placemarks, error in
            guard let placemark = placemarks?.first, let city = placemark.locality, let country = placemark.country, let coordinate = placemark.location?.coordinate else {
                return
            }
            let location = Location(city: city, country: country, coordinate: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            completionHandler({ return location })
        }
    }
}
