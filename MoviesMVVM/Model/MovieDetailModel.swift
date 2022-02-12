//
//  MovieDetailModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/1/22.
//

import Foundation

// MARK: - MovieDetailModel
struct MovieDetailModel: Codable,Identifiable, Hashable {
    var identifier = UUID()
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let revenue, runtime: Int?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let credits: MovieCreditResponse?
    let releaseDate: String?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    private var format: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }
    var budgetText: String? {
        return format.string(from: NSNumber(value: budget ?? 0))
    }
    var revenuText: String? {
        return format.string(from: NSNumber(value: revenue ?? 0))
    }
    var language: String? {
        return (Locale.current as NSLocale).displayName(forKey: .languageCode, value: originalLanguage ?? "")
    }
    
    private var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }
    var releaseDateText: String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var releaseDate = ""
        if let date = dateFormat.date(from: self.releaseDate ?? "") {
            releaseDate = dateFormatter.string(from: date)
        }
        return releaseDate
    }
    
    public var voteAveragePercentText: String? {
        if Int((voteAverage ?? 0.0) * 10) == 0 {
            return nil
        }
        return "\(Int((voteAverage ?? 0.0) * 10))%"
    }
    
    var posterURL: URL {
        return URL(string: Endpoint.getPosterURL(query: posterPath ?? ""))!
    }
    var backdropURL: URL {
        return URL(string: Endpoint.getBackDropPath(query: backdropPath ?? ""))!
    }
    
    var runTimeString: String? {
        let time = runtime ?? 0
        if time == 0 {
            return nil
        }
        let hour = time / 60
        let min = time % 60
        return "\(hour)h \(min)min"
    }
    
    var ratingText: String? {
        if let rating = voteAverage {
            let rating = Int(rating)
            let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
                return acc + "⭐️"
            }
            return ratingText
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case credits = "credits"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable,Identifiable, Hashable {
    let id: Int?
    let name, posterPath, backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Genre
struct Genre: Codable,Identifiable, Hashable {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable,Identifiable, Hashable {
    let id: Int?
    let logoPath, name, originCountry: String?
    
   
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable, Hashable {
    let iso3166_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable,Hashable  {
    let englishName, iso639_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

struct MovieCreditResponse: Codable, Hashable  {
    let cast: [MovieCast]
    let crew: [MovieCrew]
    enum CodingKeys: String, CodingKey {
        case crew = "crew"
        case cast = "cast"
    }
}

struct MovieCast: Codable,Hashable {
    let id: Int?
    let character,name,profilePath: String?
    
    var profileURL: URL {
        return URL(string: Endpoint.getPosterURL(query: profilePath ?? ""))!
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case character = "character"
        case name = "name"
        case profilePath = "profile_path"
    }
}

struct MovieCrew: Codable, Hashable  {    
    let id: Int?
    let job,name,department: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case department = "department"
        case job = "job"
        case name = "name"
    }
}
