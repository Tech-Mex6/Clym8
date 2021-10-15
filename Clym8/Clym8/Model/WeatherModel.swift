//
//  WeatherModel.swift
//  Clym8
//
//  Created by meekam okeke on 6/23/21.
//

import Foundation

struct WeatherModel {
    var cityName: String
    var temperature: Double
    var weatherID: Int
    var mainDesc: String
    var weatherSummary: String
    var minTemp: Double
    var maxTemp: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var weatherCondition: String {
        switch weatherID {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...884:
            return "cloud.fill"
        default:
            return "cloud.fill"
        }
    }
}



