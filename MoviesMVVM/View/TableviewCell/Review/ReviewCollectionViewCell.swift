//
//  ReviewCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Mani on 1/31/22.
//

import UIKit
import Combine

class ReviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var authorNameLable: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewTextLabel: UILabel!
    private var binding = Set<AnyCancellable>()
    
    var data: ReviewResult? {
        didSet {
            avatarView.image = UIImage(named: "avatar")
            let receiveImage: (UIImage) -> Void = { [weak self] image in
                UIView.transition(with: self?.avatarView ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                    self?.avatarView.image = image
                    self?.avatarView.layer.cornerRadius = 20
                    self?.avatarView.layer.masksToBounds = true
                }, completion: nil)
            }
            
            if var urlString = data?.author_details?.avatarPath {
                let i = urlString.index(urlString.startIndex, offsetBy: 0)
                urlString.remove(at: i)
                if let url = URL(string: urlString) {
                    ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink(receiveCompletion: { completion in
                    }, receiveValue: receiveImage).store(in: &binding)
                }
            }else{
                avatarView.image = UIImage(named: "avatar")
            }
            let titleString = NSMutableAttributedString(attributedString: NSAttributedString(string: "A review by ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]))
            titleString.append(NSAttributedString(string: (data?.author ?? data?.author_details?.username ?? "")))
            authorNameLable.attributedText = titleString
            
            if let rating = data?.author_details?.rating {
                ratingLabel.text =  "Rating: \(rating)"
            }else{
                ratingLabel.text = ""
            }
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let stringDate = data?.updated_at, let date = RFC3339DateFormatter.date(from: stringDate) {
                let converFormate = DateFormatter()
                converFormate.locale = Locale(identifier: "en_US_POSIX")
                converFormate.dateFormat = "MMMM dd, yyyy"
                converFormate.timeZone = TimeZone(secondsFromGMT: 0)
                dateLabel.text = "Written by " + (data?.author ?? data?.author_details?.username ?? "") + " On " + converFormate.string(from: date)
            }            
            overviewTextLabel.text = data?.content ?? ""
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
    
    override func layoutSubviews() {
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
    }
}
