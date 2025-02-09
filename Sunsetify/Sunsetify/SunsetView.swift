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
    @State private var countdown: String = "Loading..."

    

    var body: some View {

        VStack {

            // Add the sunset image from WeatherViewController, if you want to overlay it

            Image("SunsetIcon") // This will use the image asset you've added

                .resizable()

                .scaledToFit()

                .frame(width: 150, height: 150) // You can adjust this to fit your needs

            

            // Display weather information if available

            if let weatherData = weatherData {

                Text("The sun sets at \(formattedSunsetTime())")

                    .font(.custom("", size: 15))

                    .padding()

                

                Text("Countdown: \(countdown)")
                    .font(.headline)
                    .padding()
                    .lineLimit(nil)  // Allow the text to wrap onto multiple lines
                    .fixedSize(horizontal: false, vertical: true)  // This ensures the text wraps and adjusts vertically


                

                VStack {

                    Text("\(weatherData.locationName)")

                        .font(.title2).bold()

                    Text("\(weatherData.condition)")

                        .font(.body).bold()

                        .foregroundColor(.gray)

                }

            } else {

                // Display a progress view while weather data is being fetched

                ProgressView()

            }

            

            if let placeData = placeData {

                // Display scenic places

                VStack {

                    Text("Scenic places near you:")

                        .font(.headline)

                    Text(placeData.scenicPlace)

                        .padding()

                }

                

                

            } else {

                Text("No scenic places found.")

                    .padding()

            }



        }

        .onAppear {

            // Request location when the view appears

            locationManager.requestLocation()

        }

        .onReceive(locationManager.$location) { location in

            // Fetch weather data when the location is updated

            guard let location = location else { return }

            // Run both network calls concurrently

            Task {

                // Fetch weather data and scenic places concurrently

                async let weatherTask = fetchWeatherData(for: location)

                async let placesTask = fetchScenicPlaces(for: location)

                

                // Wait for both tasks to complete

                await weatherTask

                await placesTask

            }

    }

        .onChange(of: weatherData) { newValue in

                    // Start updating the countdown after the weather data is available

                    updateCountdown()

                }

}

    

    // Fetch weather data for the given location

    private func fetchWeatherData(for location: CLLocation) async {

        let apiKey = "e72fa29aeb8695db9c6c8d3bcbba3e1d"

        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"

        

        guard let url = URL(string: urlString) else { return }

        

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            let decoder = JSONDecoder()

            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)

            

            DispatchQueue.main.async {

                weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, sunsetTime: weatherResponse.sys.sunset, condition: weatherResponse.weather.first?.description ?? "")

            }

        } catch {

            print("Error fetching weather data: \(error.localizedDescription)")

        }

    }



    private func fetchScenicPlaces(for location: CLLocation) async {

        let apiKey = "c4bfb41df2aa4f51aa1864c19649afd6"

        let radius = 5000

        let urlString = "https://api.geoapify.com/v2/places?categories=tourism&filter=circle:\(location.coordinate.longitude),\(location.coordinate.latitude),\(radius)&apiKey=\(apiKey)"

        

        guard let url = URL(string: urlString) else { return }

        

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            let decoder = JSONDecoder()

            let geoapifyResponse = try decoder.decode(GeoapifyResponse.self, from: data)

            

            DispatchQueue.main.async {

                if let firstPlace = geoapifyResponse.features.first {

                    placeData = PlaceData(scenicPlace: firstPlace.properties.name)

                }

            }

        } catch {

            print("Error fetching scenic places: \(error.localizedDescription)")

        }

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

    

    private func updateCountdown() {

        guard let sunsetTime = weatherData?.sunsetTime else { return }

        

        // Convert sunset time to Date

        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunsetTime))

        

        // Create a timer that updates every second

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in

            let currentTime = Date()

            let remainingTime = sunsetDate.timeIntervalSince(currentTime)

            

            if remainingTime > 0 {

                let hours = Int(remainingTime) / 3600

                let minutes = (Int(remainingTime) % 3600) / 60

                let seconds = Int(remainingTime) % 60

                

                // Update the countdown text

                if hours > 0 {

                    countdown = "\(hours) hrs \(minutes) mins to sunset"

                } else if minutes > 0 {

                    countdown = "\(minutes) mins \(seconds) secs to sunset"

                } else {

                    countdown = "\(seconds) secs to sunset"

                }

            } else {

                countdown = "Sunset has passed!"

            }

        }

    }

}



#Preview {

    SunsetView()

}
