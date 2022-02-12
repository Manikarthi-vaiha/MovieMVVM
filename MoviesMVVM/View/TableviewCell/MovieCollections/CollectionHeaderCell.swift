//
//  CollectionHeaderCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit
import Combine

class CollectionHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterPath: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var OverView: UILabel!
    @IBOutlet weak var numberOfMovies: UILabel!
    var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var data: MovieCollectionModel? {
        didSet{
            
            if let posterURL = data?.posterImageURL {
                let receiveImage: (UIImage) -> Void = { [weak self] image in
                    guard let self = self else {
                        return
                    }
                    UIView.transition(with: self.backdropImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.posterPath.image = image
                    }, completion: nil)
                }
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: posterURL).sink(receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        UIView.transition(with: self.backdropImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.backdropImage.image = UIImage(named: "PlaceHolder")
                        }, completion: nil)
                    }
                }, receiveValue: receiveImage).store(in: &binding)
            }
            
            if let url = data?.backimageURL {
                let receiveImage: (UIImage) -> Void = { [weak self] image in
                    guard let self = self else {
                        return
                    }
                    UIView.transition(with: self.backdropImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.backdropImage.image = image
                    }, completion: nil)
                }
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink(receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        UIView.transition(with: self.backdropImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.backdropImage.image = UIImage(named: "PlaceHolder")
                        }, completion: nil)
                    }
                }, receiveValue: receiveImage).store(in: &binding)
            }
            OverView.text = data?.overview
            collectionTitle.text = "Part of the \(self.data?.name ?? "")"
            numberOfMovies.text = "Number of Movies " + "\(data?.parts?.count ?? 0)"
        }
    }
}
