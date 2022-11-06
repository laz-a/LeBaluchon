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
    private let locationManager = CLLocationManager()

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

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    /*
    // MARK: - Navigation
    */

    @IBAction func dismissKeyboard(_ sender: Any) {
        searchLocationTextField.resignFirstResponder()
    }

    @IBAction func tappedSearchButton(_ sender: UIButton) {
        dismissKeyboard(sender)
        guard let searchLocation = searchLocationTextField.text, !searchLocation.isEmpty else {
            return
        }
        weatherForLocation(searchLocation)
    }

    private func displayAlertError(message: String) {
        let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(errorAlertController, animated: true)
    }

    private func weatherForLocation(_ location: String) {
        weatherModel.getWeatherForLocation(location: location) { getSearchWeather in
            do {
                let searchLocationWeather = try getSearchWeather()
                let searchLocation = searchLocationWeather.location
                let searchWeather = searchLocationWeather.weather

                self.searchLocationLabel.text = "\(searchLocation.city), \(searchLocation.country)"
                self.searchLocationTempLabel.text = String(format: "%.0f℃", searchWeather.current.temp)

                if let firstWeather = searchWeather.current.weather.first {
                    self.searchLocationWeatherIcon.image = UIImage(systemName: firstWeather.icon)
                    self.searchLocationDescriptionLabel.text = firstWeather.description.capitalized
                }

                self.dailyWeatherStackView.subviews.forEach { view in
                    self.dailyWeatherStackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }

                let daily = searchWeather.daily.dropFirst().dropLast()
                daily.forEach { day in
                    let myDate = Date(timeIntervalSince1970: TimeInterval(day.dt))
                    if let firstWeather = day.weather.first {
                        let dayWeatherView = DailyWeatherStackView(day: myDate,
                                                                   temp: day.temp.day,
                                                                   icon: firstWeather.icon)
                        self.dailyWeatherStackView.addArrangedSubview(dayWeatherView)
                    }
                }
            } catch {
                self.displayAlertError(message: error.localizedDescription)
            }
        }
    }

    private func updateCurrentInfo(latitude: Double, longitude: Double) {
        self.weatherModel.getWeatherForLocation(latitude: latitude, longitude: longitude) { getWeather in
            do {
                let locationWeather = try getWeather()
                let location = locationWeather.location
                let weather = locationWeather.weather

                self.currentLocationLabel.text = "\(location.city), \(location.country)"
                self.currentLocationTempLabel.text = String(format: "%.0f℃", weather.current.temp)

                if let currentWeather = weather.current.weather.first {
                    self.currentLocationWeatherIcon.image = UIImage(systemName: currentWeather.icon)
                    self.currentLocationDescriptionLabel.text = currentWeather.description.capitalized
                }
            } catch {
                self.displayAlertError(message: error.localizedDescription)
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            updateCurrentInfo(latitude: latitude, longitude: longitude)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            self.displayAlertError(message: "You need to allow localization")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            self.displayAlertError(message: "Localization authorization unknow error")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.displayAlertError(message: error.localizedDescription)
    }
}
