//
//  Trending.swift
//  MoviesMVVM
//
//  Created by Mani on 1/28/22.
//

import Foundation

// MARK: - Trending
struct Trending: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {                
    let poster_path : String?
    let backdrop_path : String?
    let vote_average : Double?
    let release_date : String?
    let id : Int?
    let originalName: String?
    let firstAirDate: String?
    let originalTitle: String?
    let original_language: String?
    let title: String?
    
    var posterURL: URL {
        return URL(string: Endpoint.getPosterURL(query: self.poster_path ?? ""))!
    }
    
    var backDropURL: URL {
        return URL(string: Endpoint.getBackDropPath(query: self.backdrop_path ?? ""))!
    }
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case poster_path = "poster_path"
        case vote_average = "vote_average"
        case release_date = "release_date"
        case id = "id"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originalTitle = "original_title"
        case original_language = "original_language"
        case backdrop_path = "backdrop_path"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        backdrop_path = try? values.decodeIfPresent(String.self, forKey: .backdrop_path)
        original_language = try? values.decodeIfPresent(String.self, forKey: .original_language)
        title = try? values.decodeIfPresent(String.self, forKey: .title)
        poster_path = try? values.decodeIfPresent(String.self, forKey: .poster_path)
        vote_average = try? values.decodeIfPresent(Double.self, forKey: .vote_average)
        release_date = try? values.decodeIfPresent(String.self, forKey: .release_date)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        originalName = try? values.decodeIfPresent(String.self, forKey: .originalName)
        firstAirDate = try? values.decodeIfPresent(String.self, forKey: .firstAirDate)
        originalTitle = try? values.decodeIfPresent(String.self, forKey: .originalTitle)
    }
}
