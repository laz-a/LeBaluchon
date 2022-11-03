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
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var searchLocationTextField: UITextField!
    
    
    
    @IBOutlet weak var searchLocationWeatherIcon: UIImageView!
    @IBOutlet weak var searchLocationTempLabel: UILabel!
    @IBOutlet weak var searchLocationLabel: UILabel!
    
    
    @IBOutlet weak var dailyWeatherStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        print("WeatherViewController")
        
        //updateWeather(latitude: 2.22, longitude: 3.33)
        for i in 1...6 {
            dailyWeatherStackView.addArrangedSubview(DailyWeatherStackView(day: "Le \(i)", temp: "1\(i)°C", icon: "sun.max"))
        }
    }
    
    /*
    // MARK: - Navigation
    */
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        searchLocationTextField.resignFirstResponder()
    }
    
    @IBAction func tappedSearchButton(_ sender: UIButton) {
        guard let searchLocation = searchLocationTextField.text, !searchLocation.isEmpty else {
            return
        }
        weatherModel.getWeather(location: searchLocation) { getSearchWeather in
            do {
                let searchWeather = try getSearchWeather()
                print("searchWeather")
                self.searchLocationLabel.text = "\(searchWeather.location.city), \(searchWeather.location.country)"
                self.searchLocationTempLabel.text = String(format: "%.0f℃", searchWeather.weather.current.temp)
//                if let firstWeather = searchWeather.current.weather.first, let icon = weatherIcon[firstWeather.icon] {
//                    self.searchLocationWeatherIcon.image = icon
//                }
                print(searchWeather)
                searchWeather.weather.daily.forEach { day in
                    print("------------------")
                    print(day.dt)
                    
                    let epocTime = TimeInterval(day.dt)
                    let myDate = Date(timeIntervalSince1970: epocTime)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    //dateFormatter.timeStyle = .none
                    let dateStr = dateFormatter.string(from: myDate)
                    print("Converted Time :: \(dateStr)")
                    
                    print(day.temp)
                    print(day.weather.first?.icon)
                    print("------------------")
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    private func updateCurrentInfo(latitude: Double, longitude: Double) {
        self.weatherModel.getWeather(latitude: latitude, longitude: longitude) { getWeather in
            do {
                let weather = try getWeather()
//                self.currentLocationLabel.text = "\(location.city), \(location.country)"
                self.currentLocationTempLabel.text = String(format: "%.0f℃", weather.current.temp)
                if let currentWeather = weather.current.weather.first, let iconImage = UIImage(systemName: currentWeather.icon) {
                    self.currentLocationWeatherIcon.image = iconImage
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func updateWeather(latitude: Double, longitude: Double) {
        weatherModel.getWeather(latitude: latitude, longitude: longitude) { getWeather in
            do {
                let weather = try getWeather()
//                print(weather)
                
            } catch {
                print(error)
            }
        }
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("\(latitude) :: \(longitude)")
            updateCurrentInfo(latitude: latitude, longitude: longitude)
        }
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            print("locationManagerDidChangeAuthorization :: pas kool")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("locationManagerDidChangeAuthorization :: pas kool default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
