//
//  MovieCastPassionModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import Foundation
// MARK: - MovieCastPassionModel
struct MovieCastPassionModel: Codable, Identifiable, Hashable{
    var cast, crew: [PassionCast]?
    let id: Int?
}

// MARK: - Cast
struct PassionCast: Codable,Identifiable, Hashable {
    var identifier = UUID()
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    let character, creditID: String?
    let order: Int?
    let department, job: String?
    let name: String?
    let first_air_date: String?
        
    var releaseDateWithFormat: Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.date(from: self.releaseDate ?? "") ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case first_air_date = "first_air_date"
        case name = "name"
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity, character
        case creditID = "credit_id"
        case order, department, job
    }   
}


