//
//  APIService.swift
//  Sungram
//
//  Created by Johnson, Courtney M on 2/8/25.
//

import Foundation


class APIService {
    
    static let shared = APIService()
    
    
    func getAccessTokenURL() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.authHost
        components.path = "/authorize"
        
        components.queryItems = APIConstants.authParams.map({URLQueryItem(name: $0, value: $1)})
        
        guard let url = components.url else { return nil }
        
        return URLRequest(url: url)
    }
    
    func createURLRequest(moodField:String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.apiHost
        components.path = "/v1/search"
        
        components.queryItems = [
            URLQueryItem(name: "type", value: "track"),
            URLQueryItem(name: "query", value: moodField)
        ]
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        let token: String = UserDefaults.standard.value(forKey: "Authorization") as! String
        
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    func search(moodField:String) async throws -> [String] {
        guard let urlRequest = createURLRequest(moodField: moodField) else { throw NetworkError.invalidURL }
        
//        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                print("Response Error: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
            }
        }
        let decoder = JSONDecoder()
        let results = try decoder.decode(Response.self, from: data)
        
        var songInfo: [String] = []
        let items = results.tracks.items
        let song = items.shuffled()
        let songs = song.map({$0.name})
        let songsID = song.map({$0.id})
        let songsArtists = song.map({$0.artists})
        guard let songTitle = songs.first else { return [""] }
        guard let songTitleID = songsID.first else { return [""] }
        guard let songArtists = songsArtists.first else {return [""] }
        songInfo.append(songTitle)
        
        return songInfo
    }
    
    
}

struct Response: Codable {
    let tracks: Track
}

struct Track: Codable {
    let items: [Item]
}

struct Item: Codable {
    let name: String
    let id: String
    let artists: [Artist]
        
    struct Artist: Codable {
        let name: String
    }
}
