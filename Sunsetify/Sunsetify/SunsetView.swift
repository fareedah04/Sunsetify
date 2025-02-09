//
//  SunsetView.swift
//  Sunsetify
//
//  Created by Ajisegiri, Fareedah I on 2/8/25.
//

import SwiftUI
import CoreLocation

// Define the ContentView struct, which represents the main view
struct SunsetView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    @State private var placeData: PlaceData?
    
    var body: some View {
        VStack {
            // Display weather information if available
            if let weatherData = weatherData {
                Text("The sun sets at \(formattedSunsetTime())")
                    .font(.custom("", size: 10))
                    .padding()
                
                VStack {
                    Text("\(weatherData.locationName)")
                        .font(.title2).bold()
                    Text("\(weatherData.condition)")
                        .font(.body).bold()
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("CodeLab")
                    .bold()
                    .padding()
                    .foregroundColor(.gray)
            } else {
                // Display a progress view while weather data is being fetched
                ProgressView()
            }
            if let placeData = placeData {
                // Display scenic places
                VStack {
                    Text("Scenic places near you: \(placeData.scenicPlace)")
                        .font(.headline)
                }
                .padding()
            } else {
                Text("No scenic places found.")
                    .padding()
            }

        }
        .frame(width: 300, height: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .onAppear {
            // Request location when the view appears
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            // Fetch weather data when the location is updated
            guard let location = location else { return }
            fetchWeatherData(for: location)
            fetchScenicPlaces(for: location)
        }
    }
    
    // Fetch weather data for the given location
    private func fetchWeatherData(for location: CLLocation) {
        let apiKey = "e72fa29aeb8695db9c6c8d3bcbba3e1d"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        // Make a network request to fetch weather data
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // Update the weatherData state with fetched data
                    weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, sunsetTime: weatherResponse.sys.sunset, condition: weatherResponse.weather.first?.description ?? "")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchScenicPlaces(for location: CLLocation)
    {
        let apiKey = "027d290769c4458a81b263f9ad7c22ec"
        let urlString = "https://api.geoapify.com/v2/places?categories=tourism&filter=circle:\(location.coordinate.longitude),\(location.coordinate.latitude),\(5000)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
                
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data else { return }
                    
                    do {
                        let decoder = JSONDecoder()
                        let geoapifyResponse = try decoder.decode(GeoapifyResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            placeData = PlaceData(scenicPlace: geoapifyResponse.features.first?.properties.first?.name ?? "")
                        }
                    } catch {
                        print("Geoapify API Error: \(error.localizedDescription)")
                    }
                }.resume()
    }
    
    // Convert Unix timestamp to a formatted time string
    private func formattedSunsetTime() -> String {
        guard let sunsetTime = weatherData?.sunsetTime else { return "N/A" }
        
        // Convert Unix timestamp to Date
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunsetTime))
        
        // Set up the DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"  // Example: "6:45 PM"
        dateFormatter.timeZone = TimeZone.current  // Convert to the local time zone
        
        // Format the date into a string
        return dateFormatter.string(from: sunsetDate)
    }
}

#Preview {
    SunsetView()
}
