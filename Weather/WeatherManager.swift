//
//  WeatherManager.swift
//  Weather
//
//  Created by Oskar Kulig on 01/06/2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=5f0a5ecd403f2d5aebeda32606d38001&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)

            let todayConditionId = decodedData.list[0].weather[0].id
            let tomorrowConditionId = decodedData.list[8].weather[0].id
            let todayTemperature = decodedData.list[0].main.temp
            let tomorrowTemperature =  decodedData.list[8].main.temp
            let cityCountry = decodedData.city.cityCountry()
            
            let weather = WeatherModel(todayConditionId: todayConditionId, todayTemperature: todayTemperature, tomorrowConditionId: tomorrowConditionId, tomorrowTemperature: tomorrowTemperature, cityCountryName: cityCountry)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
}
