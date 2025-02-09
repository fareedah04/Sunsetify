//
//  WeatherData.swift
//  WeatherAppTutorial
//
//  Created by Eymen on 16.07.2023.
//

// Import necessary frameworks
import Foundation
import CoreLocation

// Define a struct to hold weather data
struct WeatherData: Equatable {
    let locationName: String
    let temperature: Double
    let sunsetTime: Int
    let condition: String
}

// Define a struct to represent the weather response
struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [Weather]
    let sys: SunsetInfo
}

struct SunsetInfo: Codable {
    let sunset: Int
}

// Define a struct to represent the main weather details
struct MainWeather: Codable {
    let temp: Double
}

// Define a struct to represent the weather description
struct Weather: Codable {
    let description: String
}

struct PlaceData {
    let scenicPlace: String
    //let imageUrl: String
}

// Geoapify API response models
struct GeoapifyResponse: Codable {
    let features: [ScenicPlace]
}

struct ScenicPlace: Codable {
    let properties: Properties
}

struct Properties: Codable {
    let name: String
   // let datasource: DataSource
}

//struct DataSource: Codable {
//    let raw: Raw
//}
//
//struct Raw: Codable {
//    let image: String
//}

// Define a class to manage location and update it
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // Request the user's location
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Delegate method called when the location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    // Delegate method called when an error occurs in location updates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
