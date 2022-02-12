//
//  MoviesCollectionCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/1/22.
//

import UIKit
import Combine

class MoviesCollectionCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var backdropPath: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var collectionListLabel: UITextView!
    var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    
        
    var data: MovieCollectionModel? {
        didSet{
            if let url = data?.backimageURL {
                UIView.transition(with: self.backdropPath, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.collectionListLabel.text = "Includes \((self.data?.parts ?? []).map { $0.title ?? ""  }.joined(separator: ", "))"
                    self.headerTitle.text = "Part of the \(self.data?.name ?? "")"
                    self.backdropPath.image = UIImage(named: "PlaceHolder")
                }, completion: nil)
                let receiveImage: (UIImage) -> Void = { [weak self] image in
                    guard let self = self else {
                        return
                    }
                    UIView.transition(with: self.backdropPath, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.collectionListLabel.text = "Includes \((self.data?.parts ?? []).map { $0.title ?? ""  }.joined(separator: ", "))"
                        self.headerTitle.text = "Part of the \(self.data?.name ?? "")"
                        self.backdropPath.image = image
                    }, completion: nil)
                }
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink(receiveCompletion: { completion in
                    if case .failure(_) = completion {
                        UIView.transition(with: self.backdropPath, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.collectionListLabel.text = "Includes \((self.data?.parts ?? []).map { $0.title ?? ""  }.joined(separator: ", "))"
                            self.headerTitle.text = "Part of the \(self.data?.name ?? "")"
                            self.backdropPath.image = UIImage(named: "PlaceHolder")
                        }, completion: nil)
                    }
                }, receiveValue: receiveImage).store(in: &binding)
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
        
        container.layer.borderColor = UIColor.white.cgColor
        container.layer.borderWidth = 0.3        
        
        backdropPath.layer.cornerRadius = 15
        backdropPath.layer.masksToBounds = true
        
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        
    }
    
}
