//
//  CompanyDetailsViewModel.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import Foundation
import Combine

class CompanyViewModel:ObservableObject {
    
    private lazy var bindings = Set<AnyCancellable>()
    private let model: HTTPClient!
    @Published private(set) var state: ListViewModelState = .loading
    @Published private(set) var companyDetails: CompanyDetailModel?

    init(model: HTTPClient = HTTPClient(), id: String? = nil) {
        self.model = model
        companyDetails(id: id ?? "")
    }
    
    func companyDetails(id: String) {
        let receiveOutPut: (CompanyDetailModel?) -> Void = { [weak self] respo in
            guard let self = self else { return }
            self.companyDetails = respo
        }
        let handleError: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            guard let self = self else { return }
            if case let .failure(erro) = completion {
                self.state = .error(.runtimeError(erro.localizedDescription))
            }else{
                self.state = .finishedLoading
            }
        }
        self.model.getData(url: .getCompanyDetails(companyId: id), type: CompanyDetailModel.self).sink(receiveCompletion: handleError, receiveValue: receiveOutPut).store(in: &bindings)
    }
    
}


struct CompanyDetailModel: Codable {
    var description: String?
    var headquarters: String?
    var homepage: String?
    var id: Int?
    var logo_path: String?
    var name: String?
    var origin_country: String?
    var parent_company: String?
    
    var logoPathURL:URL? {
        if let logo = logo_path {
            return URL(string:Endpoint.getPosterURL(query: logo))
        }
        return nil
    }
    
}
