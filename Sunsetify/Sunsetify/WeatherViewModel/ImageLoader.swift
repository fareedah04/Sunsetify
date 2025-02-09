//
//  ImageLoader.swift
//  Sunsetify
//
//  Created by Ajisegiri, Fareedah I on 2/8/25.
//

import SwiftUI

// Custom ImageLoader that fetches the image asynchronously
class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    
    func loadImage(from url: String) {
        guard let url = URL(string: url) else { return }
        
        // Asynchronously fetch the image from the URL
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
