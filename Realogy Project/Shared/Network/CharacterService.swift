//
//  CharacterService.swift
//  Realogy Project
//
//  Created by John Kim on 4/25/23.
//

import Foundation
import Simpsons
import TheWire

protocol CharacterServiceProtocol {
    func fetchSimpsonsData(_ package: CharacterPackages, completion: @escaping (Result<CharacterListResponse, Error>) -> Void)
}

class CharacterService : CharacterServiceProtocol {
    static let imageBaseUrl = "https://duckduckgo.com"
    let baseUrl = "http://api.duckduckgo.com"
    let simpsonsQuery = SimpsonsAPI.simpsonsQueryUrl
    let theWireQuery = TheWireAPI.theWireQueryUrl
    
    func fetchSimpsonsData(_ package: CharacterPackages, completion: @escaping (Result<CharacterListResponse, Error>) -> Void) {
        var urlString = ""
        
        switch package {
            case .simpsons:
                urlString = baseUrl + simpsonsQuery
            case .theWire:
                urlString = baseUrl + theWireQuery
        }
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Unexpected response status code", code: -1, userInfo: nil)))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(CharacterListResponse.self, from: data)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
            }
        }

      task.resume()
    }
}

enum CharacterPackages {
    case simpsons
    case theWire
}
