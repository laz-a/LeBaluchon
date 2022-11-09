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

    private let queue = DispatchQueue(label: "weatherService", attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 1)

    init() {}
    init(session: URLSession) {
        weatherService = WeatherService(session: session)
    }

    func getWeatherForLocation(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> (location: Location, weather: Weather)) -> Void) {
        queue.async {
            self.semaphore.wait()
            self.getLocation(latitude: latitude, longitude: longitude) { getLocation in
                do {
                    let location = try getLocation()
                    self.getWeather(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude) { getWeather in
                        do {
                            let weather = try getWeather()
                            completionHandler({ return (location: location, weather: weather) })
                        } catch {
                            completionHandler({ throw error })
                        }
                        self.semaphore.signal()
                    }
                } catch {
                    completionHandler({ throw error })
                    self.semaphore.signal()
                }
            }
        }
    }

    func getWeatherForLocation(location: String, completionHandler: @escaping(() throws -> (location: Location, weather: Weather)) -> Void) {
        queue.async {
            self.semaphore.wait()
            self.getLocation(from: location) { getLocation in
                do {
                    let location = try getLocation()
                    self.getWeather(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude) { getWeather in
                        do {
                            let weather = try getWeather()
                            completionHandler({ return (location: location, weather: weather) })
                        } catch {
                            completionHandler({ throw error })
                        }
                        self.semaphore.signal()
                    }
                } catch {
                    completionHandler({ throw error })
                    self.semaphore.signal()
                }
            }
        }
    }

    private func getWeather(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> Weather) -> Void) {
        weatherService.getWeather(latitude: latitude, longitude: longitude) { getWeather in
            do {
                let weather = try getWeather()
                completionHandler({ return weather })
            } catch {
                completionHandler({ throw error })
            }
        }
    }

    private func getLocation(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> Location) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first else {
                    completionHandler({ throw AsyncError.location })
                    return
                }
                if let city = placemark.locality ?? placemark.administrativeArea, let country = placemark.country {
                    let location = Location(city: city, country: country, coordinate: location)
                    completionHandler({ return location })
                }
            }
        }
    }

    private func getLocation(from city: String, completionHandler: @escaping(() throws -> Location) -> Void) {
        geocoder.geocodeAddressString(city) { placemarks, _ in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate else {
                    completionHandler({ throw AsyncError.location })
                    return
                }
                if let city = placemark.locality ?? placemark.administrativeArea, let country = placemark.country {
                    let location = Location(city: city, country: country, coordinate: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    completionHandler({ return location })
                }
            }
        }
    }
}
