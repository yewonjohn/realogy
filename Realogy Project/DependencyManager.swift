//
//  DependencyInjector.swift
//  Realogy Project
//
//  Created by John Kim on 4/24/23.
//

import Foundation

public class DependencyManager {
    
    let characterService : CharacterServiceProtocol
    
    public init() {
        self.characterService = CharacterService()
    }
}

