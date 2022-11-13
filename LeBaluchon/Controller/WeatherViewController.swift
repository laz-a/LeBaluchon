//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let weatherModel = WeatherViewModel()

    // Location manager for user localization
    private let locationManager = CLLocationManager()

    @IBOutlet weak var currentLocationStackView: UIStackView!
    @IBOutlet weak var unauthorizedLocalizationView: UIView!

    @IBOutlet weak var currentLocationWeatherIcon: UIImageView!
    @IBOutlet weak var currentLocationTempLabel: UILabel!
    @IBOutlet weak var currentLocationDescriptionLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var searchLocationTextField: UITextField!
    @IBOutlet weak var searchLocationWeatherIcon: UIImageView!
    @IBOutlet weak var searchLocationTempLabel: UILabel!
    @IBOutlet weak var searchLocationDescriptionLabel: UILabel!
    @IBOutlet weak var searchLocationLabel: UILabel!
    @IBOutlet weak var dailyWeatherStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        unauthorizedLocalizationView.isHidden = true

        // Set location manager delegate
        locationManager.delegate = self
        // Ask for location authorization
        locationManager.requestWhenInUseAuthorization()
        // Get weather for New York
        weatherForLocation("New York")
        // Check location authorization
        locationAuthorization(locationManager)
    }

    /*
    // MARK: - Navigation
    */

    // Dismiss keaybord
    @IBAction func dismissKeyboard(_ sender: Any) {
        searchLocationTextField.resignFirstResponder()
    }

    // Search location button tapped
    @IBAction func tappedSearchButton(_ sender: UIButton) {
        dismissKeyboard(sender)
        // Test TextField content
        guard let searchLocation = searchLocationTextField.text, !searchLocation.isEmpty else {
            return
        }
        // Get weather for user input
        weatherForLocation(searchLocation)
    }

    // Open app setting
    @IBAction func tappedAllowLocation(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    // Check location authorization
    private func locationAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined: break
        case .restricted, .denied:
            currentLocationStackView.isHidden = true
            unauthorizedLocalizationView.isHidden = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            currentLocationStackView.isHidden = false
            unauthorizedLocalizationView.isHidden = true
        @unknown default:
            self.displayAlertError(message: "Unknow localization error")
        }
    }

    // Get location for user input location
    private func weatherForLocation(_ location: String) {
        // Get weather for location user input
        weatherModel.getWeatherForLocation(location: location) { getSearchWeather in
            do {
                let searchLocationWeather = try getSearchWeather()
                let searchLocation = searchLocationWeather.location
                let searchWeather = searchLocationWeather.weather

                // Display location and weather informations
                self.searchLocationLabel.text = "\(searchLocation.city), \(searchLocation.country)"
                self.searchLocationTempLabel.text = String(format: "%.0f℃", searchWeather.current.temp)

                // Display weather icon and weather description
                if let firstWeather = searchWeather.current.weather.first {
                    self.searchLocationWeatherIcon.image = UIImage(systemName: firstWeather.icon)
                    self.searchLocationDescriptionLabel.text = firstWeather.description.capitalized
                }

                // Remove all sub views from dailyWeatherStackView
                self.dailyWeatherStackView.subviews.forEach { view in
                    self.dailyWeatherStackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }

                // Display next week weather
                let daily = searchWeather.daily.dropFirst().dropLast()
                daily.forEach { day in
                    let myDate = Date(timeIntervalSince1970: TimeInterval(day.dt))
                    if let firstWeather = day.weather.first {
                        // Create DailyWeatherStackView
                        let dayWeatherView = DailyWeatherStackView(day: myDate, temp: day.temp.day, icon: firstWeather.icon)
                        // Add created DailyWeatherStackView to dailyWeatherStackView
                        self.dailyWeatherStackView.addArrangedSubview(dayWeatherView)
                    }
                }
            } catch {
                // Display alert error
                self.displayAlertError(message: error.localizedDescription)
            }
        }
    }

    // Get weather for user current coordinate
    private func updateCurrentInfo(latitude: Double, longitude: Double) {
        // Get weather for coordinate
        self.weatherModel.getWeatherForLocation(latitude: latitude, longitude: longitude) { getWeather in
            do {
                let locationWeather = try getWeather()
                let location = locationWeather.location
                let weather = locationWeather.weather

                // Display location and weather informations
                self.currentLocationLabel.text = "\(location.city), \(location.country)"
                self.currentLocationTempLabel.text = String(format: "%.0f℃", weather.current.temp)

                // Display weather icon and weather description
                if let currentWeather = weather.current.weather.first {
                    self.currentLocationWeatherIcon.image = UIImage(systemName: currentWeather.icon)
                    self.currentLocationDescriptionLabel.text = currentWeather.description.capitalized
                }
            } catch {
                // Display alert error
                self.displayAlertError(message: error.localizedDescription)
            }
        }
    }
}

// Location manager delegate
extension WeatherViewController: CLLocationManagerDelegate {
    // Test location authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorization(manager)
    }

    // Get user current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Update current location weather
            updateCurrentInfo(latitude: latitude, longitude: longitude)
        }
    }

    // Location manager error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.displayAlertError(message: error.localizedDescription)
    }
}

// TextField delegate
extension WeatherViewController: UITextFieldDelegate {
    // Get wheather on keyboard Return button tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Test textField content
        guard let searchLocation = textField.text, !searchLocation.isEmpty else {
            return false
        }
        // Get weather for user input
        weatherForLocation(searchLocation)
        // Hide keayboard
        textField.resignFirstResponder()
        return true
    }
}
