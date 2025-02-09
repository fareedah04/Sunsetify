//
//  WeatherData.swift
//  Sunsetify
//
//  Created by Ajisegiri, Fareedah I on 2/8/25.
//

import Foundation
import CoreLocation


struct WeatherData
{
    let locationName: String
    let sunsetTime: Int
    let temperature: Double
    let sunVisible: Int
}

struct WeatherResponse: Codable
{
    let name: String
    let visibility: Int
    let main: MainWeather
    let weather: [Weather] //struct modeling weather response struct
    let sunsetInfo: [sys]
}

struct MainWeather: Codable
{
    let temp: Double
}

struct Weather: Codable
{
    let description: String
}

struct sys: Codable
{
    let sunset: Int
}


// Location to find curr weather
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate
{
    private let locationManager = CLLocationManager()
    @Published var location:  CLLocation?
    
    override init()
    {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation()
    {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else {return}
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
}
