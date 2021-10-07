//
//  UIImage+Extension.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import UIKit

extension UIImageView {
    
    public func set(fromUrl imageURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageURL) else { return }
        
        // Check cache
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            print("found cached image!")
            completion( UIImage(data: cachedResponse.data) )
        }
        
        // Load if cache is empty
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)
                    completion( UIImage(data: data) )
                }
            }
        }
        dataTask.resume()
    }
    
    // Image caching
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
