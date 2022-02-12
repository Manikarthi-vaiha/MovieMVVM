//
//  SearchPeopleViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/12/22.
//

import Foundation
import Combine

class SearchPeopleViewModel: ObservableObject {
    
    private lazy var bindings = Set<AnyCancellable>()
    @Published private(set) var state: ListViewModelState = .none
    private let model: HTTPClient!
    @Published private(set) var searchModel: [SearchPeopleResult] = []
    private(set) var totalPage = 1
    var pageNumber = 1
    
    
    init(model: HTTPClient = HTTPClient()) {
        self.model = model
    }
    
    func getSearchPeople(text searchText: String?,page number:Int){
        let receiveOutPut: (SearchPeopleModel?) -> Void = { [weak self] peopleData in
            guard let self = self else { return }
            if peopleData?.results?.isEmpty ?? true {
                self.state = .error(.runtimeError("No data Found"))
            }else{
                self.totalPage = peopleData?.total_pages ?? 0
                if self.pageNumber <= self.totalPage {
                    peopleData?.results?.forEach({ res in
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
                
        model.getData(url: .searchPeople(personName: searchText ?? "", pageNumber: number), type: SearchPeopleModel.self).sink(receiveCompletion: handleError, receiveValue: receiveOutPut).store(in: &bindings)
    }
    
    func reset(){
        self.searchModel = []
        totalPage = 1
        pageNumber = 1
    }
}
