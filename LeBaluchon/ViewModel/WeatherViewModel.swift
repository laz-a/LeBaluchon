//
//  WeatherViewModel.swift
//  LeBaluchon
//
//  Created by laz on 01/11/2022.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    // Weather service singleton
    private var weatherService = WeatherService.shared

    // Geocoder for user localization
    private let geocoder = CLGeocoder()

    // Create queue, allow only 1 request at a time
    private let queue = DispatchQueue(label: "weatherService", attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 1)

    init() {}

    // Init used for unit tests
    init(session: URLSession) {
        weatherService = WeatherService(session: session)
    }

    // Get weather for location : latitude/longitude
    func getWeatherForLocation(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> (location: Location, weather: Weather)) -> Void) {
        // Add fonction to queue
        queue.async {
            // Wait for completion : signal()
            self.semaphore.wait()

            // Get location for coordinate
            self.getLocation(latitude: latitude, longitude: longitude) { getLocation in
                do {
                    let location = try getLocation()
                    // Get weather for location
                    self.getWeather(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude) { getWeather in
                        do {
                            // Return location and weather
                            let weather = try getWeather()
                            completionHandler({ return (location: location, weather: weather) })
                        } catch {
                            // Throw service error
                            completionHandler({ throw error })
                        }
                        // Completion signaling to semaphore
                        self.semaphore.signal()
                    }
                } catch {
                    // Throw localization error
                    completionHandler({ throw error })
                    // Completion signaling to semaphore
                    self.semaphore.signal()
                }
            }
        }
    }

    // Get weather for location : user input
    func getWeatherForLocation(location: String, completionHandler: @escaping(() throws -> (location: Location, weather: Weather)) -> Void) {
        // Add fonction to queue
        queue.async {
            // Wait for completion : signal()
            self.semaphore.wait()

            // Get location for user input : city
            self.getLocation(from: location) { getLocation in
                do {
                    let location = try getLocation()

                    // Get weather for location
                    self.getWeather(latitude: location.coordinate.coordinate.latitude, longitude: location.coordinate.coordinate.longitude) { getWeather in
                        do {
                            // Return location and weather
                            let weather = try getWeather()
                            completionHandler({ return (location: location, weather: weather) })
                        } catch {
                            // Throw service error
                            completionHandler({ throw error })
                        }
                        // Completion signaling to semaphore
                        self.semaphore.signal()
                    }
                } catch {
                    // Throw localization error
                    completionHandler({ throw error })
                    // Completion signaling to semaphore
                    self.semaphore.signal()
                }
            }
        }
    }

    // Get weather from coordinate parameters
    private func getWeather(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> Weather) -> Void) {
        weatherService.getWeather(latitude: latitude, longitude: longitude) { getWeather in
            do {
                // Return weather object
                let weather = try getWeather()
                completionHandler({ return weather })
            } catch {
                // Throw service error
                completionHandler({ throw error })
            }
        }
    }

    // Get location (city and country) from coordinate
    private func getLocation(latitude: Double, longitude: Double, completionHandler: @escaping(() throws -> Location) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first else {
                    // Throw location error
                    completionHandler({ throw AsyncError.location })
                    return
                }
                // Get locality or administrativeArea and country
                if let city = placemark.locality ?? placemark.administrativeArea, let country = placemark.country {
                    // Return location object
                    let location = Location(city: city, country: country, coordinate: location)
                    completionHandler({ return location })
                }
            }
        }
    }

    // Get location (city, country and coordinate) from user input location
    private func getLocation(from city: String, completionHandler: @escaping(() throws -> Location) -> Void) {
        geocoder.geocodeAddressString(city) { placemarks, _ in
            DispatchQueue.main.async {
                guard let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate else {
                    // Throw location error
                    completionHandler({ throw AsyncError.location })
                    return
                }

                // Get locality if exist (or administrativeArea), country and coordinate
                if let city = placemark.locality ?? placemark.administrativeArea, let country = placemark.country {
                    // Return location object
                    let location = Location(city: city, country: country, coordinate: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    completionHandler({ return location })
                }
            }
        }
    }
}
