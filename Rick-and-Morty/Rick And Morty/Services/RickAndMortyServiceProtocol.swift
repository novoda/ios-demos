//
//  RickAndMortyServiceProtocol.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-11.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

protocol RickAndMortyServiceProtocol {
    func fetchData<T:Decodable>(url: URL, success: @escaping (T) -> (), error: @escaping (Error?) -> ())
}
