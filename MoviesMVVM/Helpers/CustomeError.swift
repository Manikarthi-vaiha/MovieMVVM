//
//  CustomeError.swift
//  MoviesMVVM
//
//  Created by Mani on 1/28/22.
//

import Foundation


enum NetworkError: Error {
    case networkError
    case invalidURL
    case apiError(String)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .apiError(let erro):
            return erro
        case .networkError:
            return "Please check your internet connection"
        case .invalidURL:
            return "invalid url please check"
        }
    }
}
