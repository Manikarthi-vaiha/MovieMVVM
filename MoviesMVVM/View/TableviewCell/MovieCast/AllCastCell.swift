//
//  AllCastCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/9/22.
//

import UIKit
import Combine

class AllCastCell: UITableViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleNameLabel: UILabel!
    private lazy var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var data:  MovieCast? {
        didSet {
            if let data = data {
                ImageLoader.init(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: data.profileURL ).sink { completion in
                } receiveValue: { [weak self] image in
                    guard let self = self else { return  }
                    UIView.transition(with: self.castImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self.castImageView.image = image
                    }, completion: nil)
                }.store(in: &binding)                
                nameLabel.animatedText(for: data.name ?? "")
                roleNameLabel.animatedText(for: data.character ?? "")
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
    
}
