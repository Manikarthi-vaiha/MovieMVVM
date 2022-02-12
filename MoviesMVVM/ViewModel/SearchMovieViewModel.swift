//
//  SearchMovieViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/6/22.
//

import Foundation
import UIKit
import Combine

class SearchMovieViewModel: ObservableObject {
    private lazy var bindings = Set<AnyCancellable>()
    @Published private(set) var state: ListViewModelState = .none
    private let model: HTTPClient!
    @Published private(set) var searchModel: [Result] = []    
    private(set) var totalPage = 1
    var pageNumber = 1
    
    init(model: HTTPClient = HTTPClient()) {
        self.model = model
    }
        
    func getSearchItem(text searchText: String?,page number:Int){
        let receiveOutPut: (Trending?) -> Void = { [weak self] trendingData in
            guard let self = self else { return }
            if trendingData?.results?.isEmpty ?? true {
                self.state = .error(.runtimeError("No data Found"))
            }else{
                self.totalPage = trendingData?.totalPages ?? 0
                if self.pageNumber <= self.totalPage {
                    trendingData?.results?.forEach({ res in
                        self.searchModel.append(res)
                    })
                }
            }
        }
        let handleError: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let self = self else { return }
            if case let .failure(erro) = completion {
                self.state = .error(.runtimeError(erro.localizedDescription))
            }else{
                self.state = .finishedLoading
            }
        }
        model.getData(url: .searchMovie(movieName: searchText ?? "", pageNumber: number), type: Trending.self).sink(receiveCompletion: handleError, receiveValue: receiveOutPut).store(in: &bindings)
    }
    
    
    func getKeyworrdMovieList(for KeywordMovieID: String?,page number:Int){
        let receiveOutPut: (Trending?) -> Void = { [weak self] trendingData in
            guard let self = self else { return }
            if trendingData?.results?.isEmpty ?? true {
                self.state = .error(.runtimeError("No data Found"))
            }else{
                self.totalPage = trendingData?.totalPages ?? 0
                if self.pageNumber <= self.totalPage {
                    trendingData?.results?.forEach({ res in
                        self.searchModel.append(res)
                    })
                }
            }
        }
        let handleError: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let self = self else { return }
            if case let .failure(erro) = completion {
                self.state = .error(.runtimeError(erro.localizedDescription))
            }else{
                self.state = .finishedLoading
            }
        }
        model.getData(url: .getKeywordMovieList(keywordID: KeywordMovieID ?? "", pageNumber: number), type: Trending.self).sink(receiveCompletion: handleError, receiveValue: receiveOutPut).store(in: &bindings)
    }
    
    func reset(){
        self.searchModel = []
        totalPage = 1
        pageNumber = 1
    }
}
