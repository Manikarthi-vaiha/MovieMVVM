//
//  ImageListViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/7/22.
//

import Foundation
import Combine


enum ImageType {
    case Person
    case Movie
}

typealias pictureType = ImageType

class MovieImageViewModel: ObservableObject {
    
    private lazy var bindings = Set<AnyCancellable>()
    @Published private(set) var state: ListViewModelState = .loading
    private let model: HTTPClient!
    @Published private(set) var imageList: [Image] = []
    var type: pictureType?
    init(model: HTTPClient = HTTPClient(), id: String? = nil,type: pictureType = .Movie) {
        self.model = model
        self.type = type
        switch type {
        case .Movie:
            getMovieImageList(endpoint: .getImages(id: id ?? ""))
        case .Person:
            getMovieImageList(endpoint: .getPersonImage(personID: id ?? ""))
        }
    }
    
    
    func getMovieImageList(endpoint: Endpoint){
        let receiveOutPut: (MovieImageModel?) -> Void = { [weak self] images in
            guard let self = self else { return }
            
            switch self.type {
            case .Movie:
                images?.backdrops?.forEach({ image in
                    self.imageList.append(image)
                })
                images?.posters?.forEach({ image in
                    self.imageList.append(image)
                })
            case .Person:
                images?.profiles?.forEach({ image in
                    self.imageList.append(image)
                })
                break
            case .none:
                break
            }
            self.state = self.imageList.isEmpty ? .error(.runtimeError("No data")) : .finishedLoading
        }
        let handleError: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let self = self else { return }
            if case let .failure(erro) = completion {
                self.state = .error(.runtimeError(erro.localizedDescription))
            }else{
                self.state = .finishedLoading
            }
        }
        self.model.getData(url: endpoint, type: MovieImageModel.self).sink(receiveCompletion: handleError, receiveValue: receiveOutPut).store(in: &bindings)
    }
}

