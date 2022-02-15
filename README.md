# Clym8
This is a basic weather app that consumes data requested from a remote server and displays the data in a UIView

<img width="456" alt="Screen Shot 2022-02-14 at 1 03 36 PM" src="https://user-images.githubusercontent.com/61053657/153929653-51745de5-f59c-47d7-89f5-b15f9bda700e.png">

# Prerequisites
The things you need to install and run this software.
- [Xcode](https://developer.apple.com/xcode/) - IDE to build and run project.

# Project Structure
This application has one major view controller 'CLWeatherVC'. This holds all the view objects responsible for displaying the downloaded data.

# Network Layer
This project is built roughly on the MVC design pattern
The network layer uses a class called 'NetworkManager' to make requests to the [openweathermap](openweathermap.org) API to get data.
To create a new request, conform to the 'NetworkManagerDelegate'
```
protocol NetworkManagerDelegate: AnyObject {
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
```
use the 'performRequest' method to request data from the server and from here you use the 'parseJSON(_ weatherData: Data)' method to parse the response received from the server.

# View Layer
This project's view layer was built programmatically using the UIKit framework.

# Model Layer
The model consists of three Codable structs; 'WeatherData', 'Main', 'Weather'. The model objects in both 'Main' and 'Weather' structs feed into the 'WeatherData' struct.

# Authors
### Meekam Okeke 



