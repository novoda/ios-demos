//
//  CharacterRepository.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-11.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(completion: @escaping (([Character]) -> Void))
    func getNextCharacters(completion: @escaping (([Character]) -> Void))
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private let charactersBaseURL = RickAndMortyService.baseURL.appendingPathComponent("character")
    
    private var nextPageURL: URL? = nil
    private let rickAndMortyService: RickAndMortyServiceProtocol = RickAndMortyService()
    
    func getCharacters(completion: @escaping (([Character]) -> Void)) {
        rickAndMortyService.fetchData(url: charactersBaseURL) { (characterList: CharactersList) in
            if let nextURLString = characterList.info.next {
                print(nextURLString)
                self.nextPageURL = URL(string: nextURLString)
            }
            
            completion(characterList.results)
        } error: { error in
            print(error.debugDescription)
            return
        }

    }
    
    func getNextCharacters(completion: @escaping (([Character]) -> Void)) {
        if let nextPageURL = nextPageURL {
            rickAndMortyService.fetchData(url: nextPageURL) { (characterList: CharactersList) in
                if let nextURLString = characterList.info.next {
                    self.nextPageURL = URL(string: nextURLString)
                }
                
                completion(characterList.results)
            } error: { error in
                print(error.debugDescription)
                return
            }
        }
    }
    
    
}
