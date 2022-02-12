//
//  Endpoint.swift
//  MoviesMVVM
//
//  Created by Mani on 1/28/22.
//

import Foundation
import UIKit


struct Endpoint  {
    let path: String
    var queryItems: [URLQueryItem]
}


extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    static func getPosterURL(query: String) -> String{
        return posterPath+query
    }
    static func getBackDropPath(query: String) -> String {
        return backDropPath+query
    }
    static func getMovieDetailEndpoint(id: String) -> Endpoint {
        return Endpoint(path: moviePath+id, queryItems: getURLQuery())
    }
            
    static func getURLQuery(pageNumber number : Int = 1) -> [URLQueryItem]{
        return [URLQueryItem(name: apiKey, value: SecratKey.key),
                URLQueryItem(name: page, value: "\(number)"),
                URLQueryItem(name: "include_adult", value: MaintainLanguge.shared.adultIsEnable ? "true":"false"),
                URLQueryItem(name: "with_original_language", value: MaintainLanguge.shared.selectedLanguage),
                URLQueryItem(name: "append_to_response", value: "credits")]
    }
    
    static func getMovie(type catagory: Catagory = .popular,pageNumber number:Int = 1) -> Endpoint {
        switch catagory {
        case .popular:
            return Endpoint(
                path: kPopularPath,
                queryItems: getURLQuery(pageNumber: number)
            )
        case .latest:
            return Endpoint(
                path: klatest,
                queryItems: getURLQuery(pageNumber: number)
            )
        case .top_rated:
            return Endpoint(
                path: kTrendingPath,
                queryItems: getURLQuery(pageNumber: number)
            )
        case .upcoming:
            return Endpoint(
                path: kupcomingPath,
                queryItems: getURLQuery(pageNumber: number)
            )
        case .now_playing:
            return Endpoint(
                path: knowPlaying,
                queryItems: getURLQuery(pageNumber: number)
            )
        case .none:
            return Endpoint(
                path: moviePath,
                queryItems: getURLQuery(pageNumber: number)
            )
        }
    }
    static func getReview(id: String) -> Endpoint{
        return Endpoint(path: moviePath+id+"/reviews", queryItems: getURLQuery())
    }
    static func getMovieCollection(id: String)->Endpoint{
        return Endpoint(path: collectionPath+id, queryItems: getURLQuery())
    }
    static func getVideoURL(id: String) -> Endpoint {
        return Endpoint(path: moviePath+id+"/videos", queryItems: [
            URLQueryItem(name: apiKey, value: SecratKey.key),
            URLQueryItem(name: "include_adult", value: MaintainLanguge.shared.adultIsEnable ? "true":"false"),
            URLQueryItem(name: "language", value: MaintainLanguge.shared.selectedLanguage),
            URLQueryItem(name: "include_image_language", value: "en,pt,es,de,null")
        ])
    }
    static func getImages(id: String) -> Endpoint {
        return Endpoint(path: moviePath+id+"/images", queryItems: [
            URLQueryItem(name: apiKey, value: SecratKey.key),
            URLQueryItem(name: "include_adult", value: MaintainLanguge.shared.adultIsEnable ? "true":"false"),
            URLQueryItem(name: "language", value: MaintainLanguge.shared.selectedLanguage),
            URLQueryItem(name: "include_image_language", value: "en,pt,es,de,null")
        ])
    }
    static func getKeywordMovieList(keywordID id: String, pageNumber: Int) -> Endpoint {
        return Endpoint(path: kkeywordID+id+"/movies", queryItems: getURLQuery(pageNumber: pageNumber))
    }
    static func getWatchProviders(id: String) -> Endpoint {
        return Endpoint(path: moviePath+id+"/watch/providers", queryItems: getURLQuery())
    }
    static func getKeywords(id: String) -> Endpoint {
        return Endpoint(path: moviePath+id+"/keywords", queryItems: getURLQuery())
    }
    static func getPersionDetails(id: String) -> Endpoint {
        return Endpoint(path: "/3/person/"+id, queryItems: getURLQuery())
    }
    static func getPersionMovieCredits(id: String) -> Endpoint {        
        return Endpoint(path: "/3/person/"+id+"/combined_credits", queryItems: getURLQuery())
    }
    static func getPersonImage(personID id: String) -> Endpoint {
        return Endpoint(path: "/3/person/"+id+"/images", queryItems: getURLQuery())
    }
    static func searchMovie(movieName movie:String,pageNumber: Int) -> Endpoint{
        var query = getURLQuery(pageNumber: pageNumber)
        query.append(URLQueryItem(name: "query", value: movie))
        return Endpoint(path: ksearch, queryItems: query)
    }
    static func getSocialMediaIcon(personID id: String) -> Endpoint{
        return Endpoint(path: "/3/person/"+id+"/external_ids", queryItems: getURLQuery())
    }
    static func getCompanyDetails(companyId id: String) -> Endpoint {
        return Endpoint(path: "/3/company/"+id, queryItems: [URLQueryItem(name: apiKey, value: SecratKey.key)])
    }
    static func searchPeople(personName text: String,pageNumber: Int) -> Endpoint{
        var query = getURLQuery(pageNumber: pageNumber)
        query.append(URLQueryItem(name: "query", value: text))
        return Endpoint(path: "/3/search/person", queryItems: query)
    }
}


