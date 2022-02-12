//
//  HTTPClient.swift
//  MoviesMVVM
//
//  Created by Mani on 1/28/22.
//

import Foundation
import Combine
import UIKit


class HTTPClient {
    init() {}
    private var cancellable = Set<AnyCancellable>()
    
    func getData<T: Decodable>(url: Endpoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = url.url else {
                return promise(.failure(NetworkError.invalidURL))
            }
            print("URL: ", url.absoluteURL)
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else{
                        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                             {
                            print("Error Response: --> ", json)
                            if let message = json["status_message"] as? String {
                                throw NetworkError.apiError(message)
                            }else{
                                if let error = json["errors"] as? NSArray, let errorMsg = error.firstObject as? String {
                                    throw NetworkError.apiError(errorMsg)
                                }else{
                                    throw NetworkError.networkError
                                }
                            }
                        }
                        throw NetworkError.networkError
                    }
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print("Response: --> ", json)
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.networkError))
                        }
                    }
                } receiveValue: { promise(.success($0))  }
                .store(in: &self.cancellable)
        }
    }
}


