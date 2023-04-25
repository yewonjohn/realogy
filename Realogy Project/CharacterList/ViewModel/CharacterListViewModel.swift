//
//  CharacterListViewModel.swift
//  Realogy Project
//
//  Created by John Kim on 4/25/23.
//

import Foundation

protocol CharacterListViewModelProtocol {
    
    func fetchCharacters(_ package: CharacterPackages, completion: @escaping ([Character]) -> Void)
}

class CharacterListViewModel : CharacterListViewModelProtocol {
    
    let characterService : CharacterServiceProtocol
    
    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
    }

    func fetchCharacters(_ package: CharacterPackages, completion: @escaping ([Character]) -> Void) {
        
        characterService.fetchSimpsonsData(package) { (result) in
            switch result {
                case .success(let response):
                let characterResponse = response.characters
                var characters = [Character]()
                
                for char in characterResponse {
                    //Using a placeholder here
                    let iconUrl = char.icon.url == "" ? "/i/cb4121fd.png" : char.icon.url
                    let imageUrl = CharacterService.imageBaseUrl + (iconUrl ?? "")
                    print(imageUrl)
                    var name = ""
                    var description = char.description

                    if let index = char.description?.firstIndex(of: "-") {
                        let nameSubstring = char.description?.prefix(upTo: index).trimmingCharacters(in: .whitespaces)
                        let descSubstring = char.description?.suffix(from: index).trimmingCharacters(in: .whitespaces).dropFirst()
                        
                        name = nameSubstring ?? "Name N/A"
                        if let desc = descSubstring {
                            description = String(desc)
                        }
                    }
                    
                    let character = Character(imageUrl: imageUrl, name: name, description: description)
                    characters.append(character)
                }
                    completion(characters)
                case .failure(let error):
                    //Didn't have time to address a proper error handling response/dialog
                    print(error)
            }
        }
    }
}
