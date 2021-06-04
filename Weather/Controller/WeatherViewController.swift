//
//  ViewController.swift
//  Weather
//
//  Created by Oskar Kulig on 01/06/2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tomorrowImageView: UIImageView!
    @IBOutlet weak var tomorrowTemperatureLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

private extension WeatherViewController {
    func handle(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: "An awful error occured",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default
        ))

        present(alert, animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Enter City Name!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.todayTemperatureString
            self.cityLabel.text = weather.cityCountryName
            self.conditionImageView.image = UIImage(systemName: weather.todayConditionName)
            self.tomorrowImageView.image = UIImage(systemName: weather.tomorrowConditionName)
            self.tomorrowTemperatureLabel.text = weather.tomorrowTemperatureString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.handle(error)
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.handle(error)
        }
    }
}
