//
//  MovieCollectionModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/1/22.
//

import Foundation

// MARK: - MovieCollectionModel
struct MovieCollectionModel: Codable {
    let id: Int?
    let name, overview, posterPath, backdropPath: String?
    let parts: [Part]?

    var backimageURL:URL {
        return URL(string: Endpoint.getBackDropPath(query: backdropPath ?? ""))!
    }
    
    var posterImageURL:URL {
        return URL(string: Endpoint.getPosterURL(query: posterPath ?? ""))!
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case parts
    }
}

// MARK: - Part
struct Part: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let title, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    var posterURL: URL {
        return URL(string: Endpoint.getPosterURL(query: posterPath ?? ""))!
    }
    
    private var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }
    var releaseDateText: String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy, MMMM, dd"
        var releaseDate = ""
        if let date = dateFormat.date(from: self.releaseDate ?? "") {
            releaseDate = dateFormatter.string(from: date)
        }
        return releaseDate
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
