//
//  CollectionPartsCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit
import Combine

class CollectionPartsCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var relaseDate: UILabel!
    var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var data: Part?{
        didSet {            
            if let date = data?.releaseDateText, !date.isEmpty {
                relaseDate.text = date
            }
            if let rating = data?.voteAverage {
                movieRating.text = "⭐️ " + "\(rating)"
            }
            if let title = data?.title {
                movieTitle.text = title
            }
            if let poster = data?.posterURL {
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: poster).sink { err in
                } receiveValue: { [weak self] image in
                    UIView.transition(with: self?.posterImageView ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                        guard let self = self else { return }
                        self.posterImageView.image = image
                    }, completion: nil)
                }.store(in: &bindings)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        [container,posterImageView].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
    }
}
