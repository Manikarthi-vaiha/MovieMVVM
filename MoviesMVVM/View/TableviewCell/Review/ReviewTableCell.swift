//
//  ReviewTableCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/9/22.
//

import UIKit
import Combine

class ReviewTableCell: UITableViewCell {

    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var bindings: Set<AnyCancellable>  = Set<AnyCancellable>()
    
    var data: ReviewResult? {
        didSet {
            let receiveImage: (UIImage) -> Void = { [weak self] image in
                UIView.transition(with: self?.profileImage ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                    self?.profileImage.image = image
                    self?.profileImage.layer.cornerRadius = 25
                    self?.profileImage.layer.masksToBounds = true
                }, completion: nil)
            }
            
            if var urlString = data?.author_details?.avatarPath {
                let i = urlString.index(urlString.startIndex, offsetBy: 0)
                urlString.remove(at: i)
                if let url = URL(string: urlString) {
                    ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink(receiveCompletion: { completion in
                    }, receiveValue: receiveImage).store(in: &bindings)
                }
            }else{
                profileImage.image = UIImage(named: "avatar")
            }
            let titleString = NSMutableAttributedString(attributedString: NSAttributedString(string: "A review by ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]))
            titleString.append(NSAttributedString(string: (data?.author ?? data?.author_details?.username ?? "")))
            authorNameLabel.attributedText = titleString
            
            if let rating = data?.author_details?.rating {
                ratingLabel.text = " | ⭐️ " + "\(rating)"
            }
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let stringDate = data?.updated_at, let date = RFC3339DateFormatter.date(from: stringDate) {
                let converFormate = DateFormatter()
                converFormate.locale = Locale(identifier: "en_US_POSIX")
                converFormate.dateFormat = "MMMM dd, yyyy"
                converFormate.timeZone = TimeZone(secondsFromGMT: 0)
                updatedDateLabel.text = "Written by " + (data?.author ?? data?.author_details?.username ?? "") + " On " + converFormate.string(from: date)
            }
            
            overviewLabel.text = data?.content ?? ""
        }
    }
        
}
