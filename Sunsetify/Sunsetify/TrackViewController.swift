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
        self.view.backgroundColor = .clear
        print("App loaded")
        
        pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        
        setGradientBackground()
        addBlurEffect()
        addFloatingClouds()
        // Styling the search bar (moodField)
         styleMoodField()
        
    }
    
    private func styleMoodField() {
        // Set the background color of the text field
        moodField.backgroundColor = UIColor.white.withAlphaComponent(0.7)  // Light, transparent background

        // Set corner radius for rounded corners
        moodField.layer.cornerRadius = 15.0
        moodField.clipsToBounds = true

        // Set padding inside the text field (left and right padding)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: moodField.frame.height))
        moodField.leftView = paddingView
        moodField.leftViewMode = .always

        // Set the font and font size for the text
        moodField.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        // Set the text field placeholder text style
        moodField.placeholder = "What's the vibe???"
        moodField.attributedPlaceholder = NSAttributedString(
            string: "What's the vibe???",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )

        // Set border properties
        moodField.layer.borderWidth = 1.0
        moodField.layer.borderColor = UIColor.white.cgColor  // White border for contrast

        // Add an inner shadow (optional aesthetic touch)
        moodField.layer.shadowColor = UIColor.black.cgColor
        moodField.layer.shadowOffset = CGSize(width: 0, height: 2)
        moodField.layer.shadowOpacity = 0.3
        moodField.layer.shadowRadius = 4
    }
    
    
    private func setGradientBackground() {
        print("InsideSetGradient")

        self.view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds

        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.65, blue: 0.7, alpha: 1.0).cgColor,  // Warm pink
            UIColor(red: 0.9, green: 0.7, blue: 0.9, alpha: 1.0).cgColor,  // Lavender
            UIColor(red: 1.0, green: 0.75, blue: 0.5, alpha: 1.0).cgColor,  // Peach
            UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0).cgColor   // Soft yellow
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light) // Use .dark for a darker effect
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        blurView.alpha = 0.3 // Adjust for subtle effect
        self.view.insertSubview(blurView, at: 1)
    }

    private func addFloatingClouds() {
        let cloudImage = "cloud1" // Your single cloud image name

        // Define **fixed** Y positions to prevent overlap
        let cloudData: [(y: CGFloat, size: CGFloat, speed: Double)] = [
            (y: 100, size: 350, speed: 30), // High cloud, big, slow
            (y: 230, size: 400, speed: 50), // Middle cloud, large, medium speed
            (y: 330, size: 200, speed: 35), // Lower cloud, smaller
            (y: 380, size: 300, speed: 25), // Lower cloud, smaller
        ]

        for data in cloudData {
            let cloud = UIImageView(image: UIImage(named: cloudImage)) // Reuse the same image
            let width = data.size
            let height = data.size * 0.6 // Maintain aspect ratio
            
            let startX = -width // Start off-screen on the left
            let endX = self.view.bounds.width + width // Move off-screen to the right
            
            cloud.frame = CGRect(x: startX, y: data.y, width: width, height: height)
            cloud.alpha = 0.9 // Keep them visible but soft

            self.view.addSubview(cloud)
            loopCloudAnimation(cloud, startX: startX, endX: endX, duration: data.speed)
        }
    }

    private func loopCloudAnimation(_ cloud: UIImageView, startX: CGFloat, endX: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration,
                       delay: Double.random(in: 0...3), // Staggered start times
                       options: [.curveLinear], // Smooth animation
                       animations: {
            cloud.frame.origin.x = endX // Move across the screen
        }) { _ in
            // Reset cloud position instantly and restart animation
            cloud.frame.origin.x = startX
            self.loopCloudAnimation(cloud, startX: startX, endX: endX, duration: duration)
        }
    }




    private func animateCloud(_ cloud: UIImageView, toX endX: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration,
                       delay: Double.random(in: 0...3), // Staggered start times
                       options: [.curveLinear, .repeat], // Repeat infinitely
                       animations: {
            cloud.frame.origin.x = endX // Move across the screen
        }, completion: nil)
    }
    
    
    @IBAction func playPausedTapped(_ sender: Any) {
        isPlaying.toggle() // Switch between true/false
        
        let buttonImage = isPlaying ? UIImage(named: "pause") : UIImage(named: "play")
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
