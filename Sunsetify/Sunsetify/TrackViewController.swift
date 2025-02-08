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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("App loaded")
        
        
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
            let songs = try await APIService.shared.search(moodField:moodField)
            print(songs)
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
