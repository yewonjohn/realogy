//
//  CharacterResponse.swift
//  Realogy Project
//
//  Created by John Kim on 4/25/23.
//

import Foundation

struct CharacterListResponse : Decodable {
    var characters : [CharacterResponse]
    
    enum CodingKeys: String, CodingKey {
        case characters = "RelatedTopics"
    }
}

struct CharacterResponse : Decodable {
    var url : String?
    var icon : CharacterIcon
    var tag : String?
    var description: String?

    enum CodingKeys : String, CodingKey {
        case url = "FirstURL"
        case icon = "Icon"
        case tag = "Result"
        case description = "Text"
    }
}

struct CharacterIcon : Decodable {
    
    var height: String?
    var url: String?
    var width: String?
    
    enum CodingKeys: String, CodingKey {
        case height = "Height"
        case url = "URL"
        case width = "Width"
    }
}
