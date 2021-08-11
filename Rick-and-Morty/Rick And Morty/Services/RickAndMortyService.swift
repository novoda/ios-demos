//
//  RickAndMortyService.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-10.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

final class RickAndMortyService: RickAndMortyServiceProtocol {
    static let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    func fetchData<T:Decodable>(url: URL, success: @escaping (T) -> (), error: @escaping (Error?) -> ()) {
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        success(decodedData)
                    }
                } catch let decodingError {
                    DispatchQueue.main.async {
                       error(decodingError)
                    }
                }
            } else {
                if requestError != nil {
                    DispatchQueue.main.async {
                        error(requestError)
                    }
                }
            }
        }.resume()
    }
}
