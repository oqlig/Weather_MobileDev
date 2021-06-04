//
//  WeatherModel.swift
//  Weather
//
//  Created by Oskar Kulig on 01/06/2021.
//
import Foundation

struct WeatherModel {
    let todayConditionId: Int
    let todayTemperature: Double
    let tomorrowConditionId: Int
    let tomorrowTemperature: Double
    let cityCountryName: String
    
    var todayTemperatureString: String {
        return String(format: "%.0f", todayTemperature)
    }
    
    var tomorrowTemperatureString: String {
        return String(format: "%.0f", tomorrowTemperature)
    }
    
    var todayConditionName: String {
        return self.getConditionName(conditionId: todayConditionId)
    }
    
    var tomorrowConditionName: String {
        return self.getConditionName(conditionId: tomorrowConditionId)
    }
    
    private
    
    func getConditionName(conditionId: Int) -> String {
        var conditionName = ""
        
        switch conditionId {
        case 200...232:
            conditionName = "cloud.bolt.rain"
        case 300...321:
            conditionName = "cloud.drizzle"
        case 500...502:
            conditionName = "cloud.rain"
        case 502...504:
            conditionName = "cloud.heavyrain"
        case 511:
            conditionName = "snow"
        case 520...531:
            conditionName = "cloud.drizzle"
        case 600...622:
            conditionName = "cloud.snow"
        case 701...711:
            conditionName = "cloud.fog"
        case 721:
            conditionName = "cloud.haze"
        case 731...771:
            conditionName = "cloud.fog"
        case 781:
            conditionName = "tornado"
        case 800:
            conditionName = "sun.max"
        case 801...803:
            conditionName = "cloud.sun"
        case 804:
            conditionName = "cloud"
        default:
            conditionName = "cloud"
        }
        return conditionName
    }
}
