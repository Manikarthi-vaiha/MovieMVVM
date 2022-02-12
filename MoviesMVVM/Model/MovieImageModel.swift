//
//  MovieImageModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import Foundation


struct MovieImageModel: Codable {
    
    let id: Int?
    let profiles: [Image]?
    let backdrops: [Image]?
    let posters: [Image]?
    
    enum Codingkeys: String {
        case id = "id"
        case profiles = "profiles"
        case backdrops = "backdrops"
        case posters = "posters"
    }
}

struct Image:Codable {
    let file_path: String?
    
    var imageURL: URL? {
        return URL(string: Endpoint.getPosterURL(query: file_path ?? ""))
    }
    enum Codingkeys: String {
        case file_path = "id"
    }
}

