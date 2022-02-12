//
//  SearchPeopleModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/12/22.
//

import Foundation


struct SearchPeopleModel:Codable {
    let id: Int?
    let page: Int?
    let results: [SearchPeopleResult]?
    let total_pages, total_results: Int?
}


struct SearchPeopleResult:Codable{
    var id: Int?
    var name: String?
    var known_for : [KnownForPeople]?
    var profile_path: String?
    
    var profileURL: URL? {
        return URL(string: Endpoint.getPosterURL(query: profile_path ?? "")) ?? nil
    }
}


struct KnownForPeople:Codable {
    var id: Int?
    var original_title: String?
}
