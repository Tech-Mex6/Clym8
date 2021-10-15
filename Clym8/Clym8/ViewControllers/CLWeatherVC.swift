//
//  CLWeatherVC.swift
//  Clym8
//
//  Created by meekam okeke on 6/24/21.
//
import CoreLocation
import UIKit

class CLWeatherVC: UIViewController {

    let vStackView       = UIStackView()
    let hStackView       = UIStackView()
    
    var conditionImageView = UIImageView()
    let locationButton     = CurrentLocationButton()
    let searchTextField    = CLTextField()
    let actionButton       = SearchButton()
    let cityNameLabel      = CLBodyLabel(textAlignment: .center, fontSize: 25)
    let temperatureLabel   = CLBodyLabel(textAlignment: .center, fontSize: 34)
    let mainLabel          = CLSecondaryTitleLabel(fontSize: 20)
    let descriptionLabel   = CLSecondaryTitleLabel(fontSize: 20)
    let minMaxLabel        = CLSecondaryTitleLabel(fontSize: 20)
      
    var weatherManager     = NetworkManager()
    let locationManager    = CLLocationManager()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureActionButton()
        configureLocationButton()
        configureHStackView()
        layoutUI()
        configureVStackView()
        
        locationManager.requestWhenInUseAuthorization()
        
        searchTextField.delegate = self
        weatherManager.delegate  = self
        locationManager.delegate = self

    }
    
    private func configureBackgroundView() {
        view.backgroundColor = .systemTeal
    }
    
    private func configureLocationButton() {
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func configureHStackView() {
        hStackView.axis         = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing      = 5
        hStackView.addArrangedSubview(locationButton)
        hStackView.addArrangedSubview(searchTextField)
        hStackView.addArrangedSubview(actionButton)
    }
    
    private func configureVStackView() {
        vStackView.axis = .vertical
        vStackView.alignment = .center
        vStackView.distribution = .fillEqually
        vStackView.addArrangedSubview(cityNameLabel)
        vStackView.addArrangedSubview(conditionImageView)
        vStackView.addArrangedSubview(temperatureLabel)
        vStackView.addArrangedSubview(mainLabel)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(minMaxLabel)
    }
    
    private func layoutUI() {
        view.addSubview(hStackView)
        view.addSubview(vStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.translatesAutoresizingMaskIntoConstraints = false
       
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            hStackView.heightAnchor.constraint(equalToConstant: 40),
            
            vStackView.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 20),
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
    }
    
    @objc func locationButtonTapped() {
        locationManager.requestLocation()
    }
    


}
//MARK: - UITextFieldDelegate

extension CLWeatherVC: UITextFieldDelegate {
    
    @objc func actionButtonTapped() {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type something"
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

extension CLWeatherVC: NetworkManagerDelegate {
    
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString)°F"
            self.cityNameLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.weatherCondition)
            self.descriptionLabel.text = weather.weatherSummary
            self.mainLabel.text = weather.mainDesc
            self.minMaxLabel.text = "\(weather.maxTemp)°F/\(weather.minTemp)°F"
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension CLWeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchCoordinates(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error\(error.localizedDescription)")
    }
    
}
