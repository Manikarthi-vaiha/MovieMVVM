//
//  HomePageViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 1/28/22.
//

import Foundation
import Combine
import UIKit


class HomePageViewModel: ObservableObject {
    
    private lazy var bindings = Set<AnyCancellable>()
    @Published private(set) var state: ListViewModelState = .loading
    private let model: HTTPClient!
    @Published private(set) var trendingModel: [Result] = []
    private(set) var totalPage = 1
    var pageNumber = 1
    var movieType: Catagory = .now_playing
    init(model: HTTPClient = HTTPClient()) {
        self.model = model
    }
    
    func getAPiResponse(page number:Int){
        let receiveOutPut: (Trending?) -> Void = { [weak self] trendingData in
            guard let self = self else { return }
            if trendingData?.results?.isEmpty ?? true {
                self.state = .error(.runtimeError("No data Found"))
            }else{
                self.totalPage = trendingData?.totalPages ?? 0
                if self.pageNumber <= self.totalPage {
                    trendingData?.results?.forEach({ res in
                        self.trendingModel.append(res)
                    })
                }
                self.state = .finishedLoading
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
        model.getData(url: .getMovie(type: movieType, pageNumber: number), type: Trending.self).sink(receiveCompletion: handleError, receiveValue: receiveOutPut).store(in: &bindings)
    }
    
    func resetData(){
        state = .loading
        trendingModel.removeAll()
        totalPage = 1
        pageNumber = 1
    }
}
