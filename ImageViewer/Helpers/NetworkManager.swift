//
//  NetworkManager.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import Foundation

class NetworkManager {
    let shared = NetworkManager()
    private init() {}
    
    static func fetchData(closure: @escaping (_: DogModelNetwork) -> Void) {
        
        let fullURL = "https://dog.ceo/api/breeds/image/random"
        let fullURLEncoded = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: fullURLEncoded!) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let dog = try decoder.decode(DogModelNetwork.self, from: data)
                closure(dog)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
