//
//  MovieDetailViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 1/31/22.
//

import Foundation
import Combine

enum ListViewModelError: Error, Equatable, LocalizedError {
    case someThingWentWrong
    case runtimeError(String)
    var errorDescription: String? {
        switch self {
        case .someThingWentWrong:
            return "something went wrong in api"
        case .runtimeError(let errorDesc):
            return errorDesc
        }
    }
    
}
enum ListViewModelState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(ListViewModelError)
}

struct MovieDetail {
    let detail: MovieDetailModel
    let review: ReviewModel
    var video: MovieVideoResponse
}


enum MovieSection {
    case MovieDetail
    case MovieCast
    case MovieReview
    case ProductionCompany
    case MoviewCollection
    case MovieKeywords
    case Media
    case MovieRecommadation
}


class MovieDetailViewModel: ObservableObject  {
    
    private let model: HTTPClient!
    @Published private(set) var movieDetail: MovieDetail?
    @Published private(set) var collections: MovieCollectionModel?
    @Published private(set) var state: ListViewModelState = .loading
    @Published private(set) var keywords: KeywordsModel?
    private var bindings = Set<AnyCancellable>()
    private(set) var movieSection = [MovieSection]()
    
    init(model: HTTPClient) {
        self.model = model
    }
    
    private func getCollection(id:String?){
        if let id = id {
            model.getData(url: .getMovieCollection(id: id), type: MovieCollectionModel.self).sink { completion in
            } receiveValue: {  [weak self] response in
                guard let self = self else { return }
                self.collections = response
                self.movieSection.append(.MoviewCollection)
            }.store(in: &bindings)
        }
    }
    
    func getAPiResponse(id:String){
        
        model.getData(url: .getKeywords(id: id), type:  KeywordsModel.self).sink { completion in
        } receiveValue: { [weak self] model in
            guard let self = self else { return }
            
            if !(model.keywords?.isEmpty ?? true) {
                self.movieSection.append(.MovieKeywords)
            }
            self.keywords = model
        }.store(in: &bindings)

        let movieResponse: (MovieDetail) -> Void = { [weak self] response in
            guard let self = self else { return }
            self.getCollection(id: "\(response.detail.belongsToCollection?.id ?? 0)")
            self.movieSection.insert(.MovieDetail, at: 0)
            
            if let count = response.detail.productionCompanies?.count, count > 1 {
                self.movieSection.insert(.ProductionCompany, at: 1)
            }
            if !(response.detail.credits?.cast.isEmpty ?? true) {
                self.movieSection.insert(.MovieCast, at: 1)
            }
            if !(response.review.results?.isEmpty ?? true) {
                self.movieSection.append(.MovieReview)
            }
            if !(response.video.results?.isEmpty ?? true) {
                self.movieSection.append(.Media)
            }
            self.movieDetail = response
        }
        let completionHandler: (Subscribers.Completion<Publishers.Zip3<Future<MovieDetailModel,Error>,Future<ReviewModel,Error>,Future<MovieVideoResponse,Error>>.Failure>) -> Void = { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let err):                
                self.state = .error(.runtimeError(err.localizedDescription))
            case .finished:
                self.state = .finishedLoading
            }
        }
        Publishers.Zip3(
            getPublisher(for: MovieDetailModel.self, endPoint:.getMovieDetailEndpoint(id: id)),
            getPublisher(for: ReviewModel.self, endPoint: .getReview(id: id)),
            getPublisher(for: MovieVideoResponse.self, endPoint: .getVideoURL(id: id))
        ).map { (detailModel, reviewModel, videoResponse) in
            return MovieDetail(detail: detailModel, review: reviewModel,video: videoResponse)
        }.sink(receiveCompletion: completionHandler, receiveValue: movieResponse)
        .store(in: &bindings)
    }
    
    
    
    
    private func getPublisher<T: Decodable>(for type: T.Type, endPoint: Endpoint)-> Future<T, Error> {
        model.getData(url: endPoint, type: T.self)
    }
}



