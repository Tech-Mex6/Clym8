//
//  NetworkManager.swift
//  Clym8
//
//  Created by meekam okeke on 6/23/21.
//
import CoreLocation
import UIKit

protocol NetworkManagerDelegate: AnyObject {
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class NetworkManager {
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=428ab326a06b6cf961ae0a34a79970dd&units=imperial"
    
    weak var delegate: NetworkManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(baseUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session   = URLSession(configuration: .default)
        let task      = session.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let _data = data {
                if let currentWeather = self.parseJSON(_data) {
                    self.delegate?.didUpdateWeather(self, weather: currentWeather)
                }
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData     = try decoder.decode(WeatherData.self, from: weatherData)
            let id              = decodedData.weather[0].id
            let temp            = decodedData.main.temp
            let name            = decodedData.name
            let mainDescription = decodedData.weather[0].main
            let summary         = decodedData.weather[0].description
            let maxTemp         = decodedData.main.tempMax
            let minTemp         = decodedData.main.tempMin
            
            
            let weather = WeatherModel(cityName: name, temperature: temp, weatherID: id, mainDesc: mainDescription, weatherSummary: summary, minTemp: minTemp, maxTemp: maxTemp)
            return weather
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

