//
//  SunsetView.swift
//  Sunsetify
//
//  Created by Ajisegiri, Fareedah I on 2/8/25.
//

import SwiftUI
import CoreLocation

struct SunsetView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    var body: some View {
            VStack {
                if let weatherData = weatherData {
                    Text("The sun sets at \(Int(weatherData.sunsetTime))")
                        .font(.custom("", size: 70))
                        .padding()
                    
                    VStack {
                        Text("\(weatherData.locationName)")
                            .font(.title2).bold()
                    }
                    
                    Spacer()
                    Text("CodeLab")
                        .bold()
                        .padding()
                        .foregroundColor(.orange)
                } else {
                    Text("uh ohhh")
                    ProgressView()
                }
            }
            .frame(width: 300, height: 300)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .onAppear {
                locationManager.requestLocation()
            }
            .onReceive(locationManager.$location) { location in
                guard let location = location else { return }
                fetchWeatherData(for: location)
            }
        }
    
    private func fetchWeatherData(for location: CLLocation)
    {
        let apiKey = "e72fa29aeb8695db9c6c8d3bcbba3e1d"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    weatherData = WeatherData(locationName:
                                                weatherResponse.name, sunsetTime: weatherResponse.sunsetInfo.first?.sunset ?? 0, temperature:
                                                weatherResponse.main.temp, sunVisible: weatherResponse.visibility)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

#Preview {
    SunsetView()
}
