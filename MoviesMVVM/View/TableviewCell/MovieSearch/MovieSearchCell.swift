//
//  MovieSearchCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/6/22.
//

import UIKit
import Combine

class MovieSearchCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    
    private lazy var bindings = Set<AnyCancellable>()
    
    var data: Result? {
        didSet {
            if let data = data {
                if let title = data.title, title.count > 0{
                    movieTitle.text = title
                }else if let title = data.originalTitle, title.count > 0 {
                    movieTitle.text = title
                }else{
                    movieTitle.text = "Movie"
                }
                languageLabel.text = (Locale.current as NSLocale).displayName(forKey: .languageCode, value: data.original_language ?? "")
                if let date = data.release_date, let firstDate = date.components(separatedBy: "-").first, !firstDate.isEmpty {
                    releaseDate.text = "Released on (" + firstDate + ")"
                }else{
                    releaseDate.text = ""
                }                
                ImageLoader(urlSession: .shared, cache: NSCache()).publisher(for: data.backDropURL).sink { err in
                } receiveValue: { [weak self] image in
                    UIView.transition(with: self?.backdropImage ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                        self?.backdropImage.image = image
                    }, completion: nil)
                }.store(in: &bindings)
                
                posterImage.image = UIImage(named: "PlaceHolder")
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: data.posterURL).sink { err in
                } receiveValue: { [weak self] image in
                    UIView.transition(with: self?.posterImage ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                        self?.posterImage.image = image
                    }, completion: nil)
                }.store(in: &bindings)
            }
        }
    }
    
    override func awakeFromNib() {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
