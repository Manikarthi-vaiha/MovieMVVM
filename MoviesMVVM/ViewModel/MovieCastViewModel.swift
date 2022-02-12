//
//  MovieCastViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import Foundation
import Combine

class MovieCastViewModel: ObservableObject  {
    
    private let model: HTTPClient!
    @Published private(set) var MovieCastDetailResponse: MovieCastModel?
    @Published private(set) var MovieCastKnownAsModel: MovieCastPassionModel?
    @Published private(set) var state: ListViewModelState = .loading
    @Published private(set) var socialMediaData: SocialMediaModel?
    private var bindings = Set<AnyCancellable>()
    var personID: String?
    @Published private(set) var titleName: String?
    
    init(model: HTTPClient, personID: String? = nil) {
        self.model = model
        self.personID = personID
    }
    func getAPiResponse(){
        if let personID = personID {
            model.getData(url: .getPersionDetails(id: personID), type:  MovieCastModel.self).sink { completion in
                if case let .failure(error) = completion {
                    self.state = .error(.runtimeError(error.localizedDescription))
                }else{
                    self.state = .finishedLoading
                }
            } receiveValue: { [weak self] model in
                guard let self = self else { return }
                self.MovieCastDetailResponse = model                
            }.store(in: &bindings)
            model.getData(url: .getPersionMovieCredits(id: personID), type: MovieCastPassionModel.self).sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] model in
                guard let self = self else { return }
                self.MovieCastKnownAsModel = model
            }.store(in: &bindings)
                        
            model.getData(url: .getSocialMediaIcon(personID: personID), type: SocialMediaModel.self).sink { completion in
                print(completion)
            } receiveValue: { [weak self] respo in
                guard let self = self else { return }
                self.socialMediaData = respo
            }.store(in: &bindings)
        }
    }
}

