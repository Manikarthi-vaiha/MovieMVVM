//
//  LanguageCode.swift
//  MoviesMVVM
//
//  Created by Mani on 2/5/22.
//

import Foundation
struct LanguageCode: Hashable {
    var selectBool: Bool
    var code: String
    var languageName: LanguageModel
}

struct LanguageModel:Hashable {
    var name: String
    var nativeName: String
}


