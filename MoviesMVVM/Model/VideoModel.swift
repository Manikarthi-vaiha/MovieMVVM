//
//  VideoModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation

struct MovieVideoResponse: Codable {
    let id: Int?
    var results: [MovieVideo]?
}

struct MovieVideo: Codable {
    let id: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
    let key: String?
    let publishedAt: String?
       
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key ?? "")")
    }
    
    var thumnailURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "http://img.youtube.com/vi/\(key ?? "")/0.jpg")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case site = "site"
        case size = "size"
        case type = "type"
        case key  = "key"
        case publishedAt = "published_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try? values.decode(String.self, forKey: .key)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        size = try? values.decode(Int.self, forKey: .size)
        site = try? values.decode(String.self, forKey: .site)
        type = try? values.decode(String.self, forKey: .type)
        publishedAt = try? values.decode(String.self, forKey: .publishedAt)
    }
}

