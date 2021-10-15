//
//  WeatherData.swift
//  Clym8
//
//  Created by meekam okeke on 6/23/21.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    var temp: Double
    var tempMin: Double
    var tempMax: Double
}

struct Weather: Codable {
    var id: Int
    var description: String
    var main: String
}
