//
//  ReviewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 1/31/22.
//

import Foundation

struct ReviewModel: Codable {
    let id, page: Int?
    let results: [ReviewResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ReviewResult: Codable,Hashable, Identifiable {
    var BoolData: String?
    let author: String?
    let author_details: AuthorDetails?
    let content, created_at, id, updated_at: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case BoolData
        case author = "author"
        case author_details = "author_details"
        case content, created_at, id, updated_at,url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try? container.decodeIfPresent(String.self, forKey: .author) ?? ""
        author_details = try? container.decodeIfPresent(AuthorDetails.self, forKey: .author_details)
        content = try? container.decodeIfPresent(String.self, forKey: .content) ?? ""
        created_at = try? container.decodeIfPresent(String.self, forKey: .created_at) ?? ""
        id = try? container.decodeIfPresent(String.self, forKey: .id) ?? ""
        updated_at = try? container.decodeIfPresent(String.self, forKey: .updated_at) ?? ""
        url = try? container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }

}

// MARK: - AuthorDetails
struct AuthorDetails: Codable, Hashable {
    let name, username: String?
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        username = try? values.decode(String.self, forKey: .username)
        avatarPath = try? values.decode(String.self, forKey: .avatarPath)
        if let rat = try? values.decode(Int.self, forKey: .rating) {
            rating = Double(rat)
        }else{
            rating = try? values.decode(Double.self, forKey: .rating)
        }
    }
}
