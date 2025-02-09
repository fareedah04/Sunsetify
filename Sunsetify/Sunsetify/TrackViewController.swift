//
//  TrackViewController.swift
//  Sunsetify
//
//  Created by Johnson, Courtney M on 2/8/25.
//

import UIKit
import WebKit

class TrackViewController: UIViewController {

    @IBOutlet weak var moodField: UITextField!
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    
    var trackID: String = ""
    var deviceID: String = ""
    
    @IBOutlet weak var pausePlayButton: UIButton!
    var isPlaying = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("App loaded")
        
        pausePlayButton.setImage(UIImage(named: "play (1)"), for: .normal)
        
        
        
    }
    
    @IBAction func playPausedTapped(_ sender: Any) {
        isPlaying.toggle() // Switch between true/false
        
        let buttonImage = isPlaying ? UIImage(named: "pause (1)") : UIImage(named: "play (1)")
        pausePlayButton.setImage(buttonImage, for: .normal)
        
                let spotifyURL = "https://open.spotify.com/track/\(trackID)"
        
                if let url = URL(string: spotifyURL) {
                    UIApplication.shared.open(url)
                }
//        Task {
//        do {
//            try await startPlayback(deviceId: deviceID, trackURI: "spotify:track:\(trackID)")
//        } catch {
//            // Handle the error, e.g. show an alert
//            print("Error starting playback: \(error.localizedDescription)")
//        }
    
    }
    
    func createActiveDeviceRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spotify.com"
        components.path = "/v1/me/player/devices"
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        let accessToken: String = UserDefaults.standard.value(forKey: "Authorization") as! String
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }

    func getActiveDevice() async throws -> String? {
        guard let urlRequest = createActiveDeviceRequest() else { throw NSError(domain: "SpotifyAPI", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to create request"]) }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            let devicesResponse = try decoder.decode(DevicesResponse.self, from: data)
            return devicesResponse.devices.first(where: { $0.isActive })?.id
        } else {
            throw NSError(domain: "SpotifyAPI", code: 404, userInfo: [NSLocalizedDescriptionKey: "No active devices found"])
        }
    }

    struct DevicesResponse: Codable {
        let devices: [Device]
    }

    struct Device: Codable {
        let id: String
        let isActive: Bool
    }
    
    func createStartPlaybackURLRequest(deviceId: String, trackURI: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.apiHost
        components.path = "/v1/me/player/play"
        
        // Add device_id as a query parameter
        components.queryItems = [
            URLQueryItem(name: "device_id", value: deviceId)
        ]
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        // Authorization: Bearer token
        let token: String = UserDefaults.standard.value(forKey: "Authorization") as! String
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the HTTP method to PUT as per the API documentation
        urlRequest.httpMethod = "PUT"
        
        // Set the request body for the playback (track URI)
        let body: [String: Any] = [
            "uris": [trackURI]
        ]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        return urlRequest
    }

    
    func startPlayback(deviceId: String, trackURI: String) async throws {
        guard let urlRequest = createStartPlaybackURLRequest(deviceId: deviceId, trackURI: trackURI) else {
            throw NSError(domain: "SpotifyAPI", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to create request"])
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
            print("Playback started successfully")
        } else {
            throw NSError(domain: "SpotifyAPI", code: 400, userInfo: [NSLocalizedDescriptionKey: "Playback failed"])
        }
    }


    
    @IBAction func generatePressed(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "Authorization") != nil {
            
            makeNetworkCall(moodField:moodField.text!)
            
        } else {
            getAccessTokenFromWebView()
        }
    }
    
    
    private func getAccessTokenFromWebView() {
        guard let urlRequest = APIService.shared.getAccessTokenURL() else { return }
        let webview = WKWebView()
        
        webview.load(urlRequest)
        webview.navigationDelegate = self
        view = webview
    }

    private func makeNetworkCall(moodField:String) {
        Task {
            let songInfo: [String] = try await APIService.shared.search(moodField:moodField)
            artistName.text = songInfo[1]
            songTitle.text = songInfo[0]
            trackID = songInfo[3]
            
            if let url = URL(string: songInfo[2]) {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.songImage.image = image
                    }
                }
            }
           
            print(songInfo)
        }
    }
}

extension TrackViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString else { return }
        print(urlString)
        
        var tokenString = ""
        if urlString.contains("#access_token=") {
            let range = urlString.range(of: "#access_token=")
            guard let index = range?.upperBound else { return }
            
            tokenString = String(urlString[index...])
        }
        
        if !tokenString.isEmpty {
            let range = tokenString.range(of: "&token_type=Bearer")
            guard let index = range?.lowerBound else { return }
            
            tokenString = String(tokenString[..<index])
            UserDefaults.standard.setValue(tokenString, forKey: "Authorization")
            webView.removeFromSuperview()
            makeNetworkCall(moodField: moodField.text!)
        }
    }
    


}
