//
//  RickAndMortyService.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-10.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

final class RickAndMortyService {
    static let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    enum ParseError: Error {
        case invalidJSON
    }
    
    func fetchData(url: URL, success: @escaping (Dictionary<String, Any>) -> (), error: @escaping (Error?) -> ()) {
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, requestError in
            if requestError != nil {
                error(requestError)
            }
            
            if let data = data {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                    DispatchQueue.main.async {
                        success(jsonResponse)
                    }
                } else {
                    error(ParseError.invalidJSON)
                }
            } else {
                error(requestError)
            }
        }.resume()
    }
}
