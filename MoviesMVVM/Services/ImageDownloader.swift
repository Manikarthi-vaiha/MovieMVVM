//
//  ImageDownloader.swift
//  MoviesMVVM
//
//  Created by Mani on 1/30/22.
//
import UIKit
import Combine
import AVKit

class ImageLoader {
    private let urlSession: URLSession
    private let cache: NSCache<NSURL, UIImage>
    
    init(urlSession: URLSession = .shared,
         cache: NSCache<NSURL, UIImage> = .init()) {
        self.urlSession = urlSession
        self.cache = cache
    }
    func publisher(for url: URL) -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: url as NSURL) {
            return Just(image)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        return  urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw URLError(.badServerResponse, userInfo: [
                        NSURLErrorFailingURLErrorKey: url
                    ])
                }
                return image
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [cache] image in
                cache.setObject(image, forKey: url as NSURL)
            })
            .eraseToAnyPublisher()
    }
        
    func getThumbnailImageFromVideoUrl(for url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let cache = NSCache<NSURL, UIImage>()
            if let image = cache.object(forKey: url as NSURL) {
                DispatchQueue.main.async { //8
                    completion(image) //9
                }
            }
            
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                cache.setObject(thumbImage, forKey: url as NSURL)
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {                
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }

}
