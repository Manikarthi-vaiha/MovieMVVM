//
//  SocialMediaModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/8/22.
//

import Foundation

struct SocialMediaModel:Codable {
    let imdb_id: String?
    let facebook_id: String?
    let tvrage_id: Int?
    let twitter_id: String?
    let instagram_id: String?
    let id: Int?
    
    enum Codingkeys:String {
        case imdb_id = "imdb_id"
        case facebook_id = "facebook_id"
        case tvrage_id = "tvrage_id"
        case twitter_id = "twitter_id"
        case instagram_id = "instagram_id"
        case id = "id"
    }
}
