//
//  KeywordsModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation


struct KeywordsModel:Codable {
    let id: Int?
    let keywords: [keywordsData]?
}

struct keywordsData: Codable {
    let id: Int?
    let name: String?
}
