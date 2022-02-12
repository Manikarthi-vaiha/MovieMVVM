//
//  imageListCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/7/22.
//

import UIKit
import Combine


class MovieImageListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    private lazy var bindings = Set<AnyCancellable>()
    var data: Image? {
        didSet {
            if let data = data, let url = data.imageURL {
                ImageLoader(urlSession: .shared, cache: NSCache()).publisher(for: url).sink { _ in
                } receiveValue: { [weak self] image in
                    guard let self = self else { return  }
                    UIView.transition(with: self.imageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                        self.imageView.image = image
                    }, completion: nil)
                }.store(in: &bindings)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
