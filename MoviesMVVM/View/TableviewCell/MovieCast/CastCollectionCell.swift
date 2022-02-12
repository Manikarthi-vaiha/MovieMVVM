//
//  CastCollectionCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import UIKit
import Combine

class CastCollectionCell: UICollectionViewCell {

    @IBOutlet weak var castProfileImage: UIImageView!
    var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var url: URL? {
        didSet {
            if let url = url {
                UIView.transition(with: self.castProfileImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.castProfileImage.image = UIImage(named: "avatar")
                }, completion: nil)
                let receiveImage: (UIImage) -> Void = { [weak self] image in
                    guard let self = self else {
                        return
                    }
                    UIView.transition(with: self.castProfileImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.castProfileImage.image = image
                    }, completion: nil)
                }
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink(receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        UIView.transition(with: self.castProfileImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.castProfileImage.image = UIImage(named: "avatar")
                        }, completion: nil)
                    }
                }, receiveValue: receiveImage).store(in: &binding)
                castProfileImage.layer.cornerRadius = self.frame.size.height/2-10
                castProfileImage.layer.masksToBounds = true
            }
        }
    }
}
