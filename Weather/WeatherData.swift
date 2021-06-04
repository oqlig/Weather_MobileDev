//
//  WeatherData.swift
//  Weather
//
//  Created by Oskar Kulig on 01/06/2021.
//

import Foundation

struct WeatherData: Decodable {
    let city: City
    let list: [DailyData]
}

struct City: Decodable {
    let name: String
    let country: String
    
    func cityCountry() -> String {
        let cityCountry = name + " " + country
        return cityCountry
    }
}

struct DailyData: Decodable {
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
