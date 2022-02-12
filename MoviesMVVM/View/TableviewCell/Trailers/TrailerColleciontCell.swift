//
//  TrailerColleciontCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import UIKit
import Combine


class TrailerColleciontCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var thumnailIMageView: UIImageView!
    var binding : Set<AnyCancellable> = Set<AnyCancellable>()
    
    var response: MovieVideo? {
        didSet{
            if let url = response?.thumnailURL {
                ImageLoader.init(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink {  completion in
                } receiveValue: { [weak self] image in
                    guard let self = self else { return }
                    UIView.transition(with: self.thumnailIMageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.thumnailIMageView.image = image
                    }, completion: nil)
                }.store(in: &binding)                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.gray.cgColor
        playView.layer.cornerRadius = 25
        playView.layer.masksToBounds = true
    }

}


