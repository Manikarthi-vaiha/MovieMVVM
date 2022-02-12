//
//  MoviePosterCell.swift
//  MoviesMVVM
//
//  Created by Mani on 1/30/22.
//

import UIKit
import Combine



class MoviePosterCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLable: UILabel!
    @IBOutlet weak var progressBar: CircularProgressBar!
    var progress : Double = 0
    var subscriptions = Set<AnyCancellable>()
    
    @objc func updateProgress() {
           
           progressBar.setProgress(to: progress, withAnimation: true)
           progress = progress + 0.06
       }
    
    var data: Result? {
        didSet {
            
        
            progressBar.labelSize = 0
            progressBar.safePercent = 100
            // Set progress value which you want to set. Progress is from 0.0 to 1.0
            progressBar.setProgress(to: progress, withAnimation: true)
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            //timer.fire()
            RunLoop.main.add(timer, forMode: .common)

            
            if let data = data {
//                ratingView.rating = (data.vote_average ?? 0.0)/2
                if let title = data.title, title.count > 0{
                    movieTitleLable.text = title + " ("+((data.firstAirDate ?? data.release_date ?? "").components(separatedBy: "-").first ?? "")+")"
                }else if let title = data.originalTitle, title.count > 0 {
                    movieTitleLable.text = title + " ("+((data.firstAirDate ?? data.release_date ?? "").components(separatedBy: "-").first ?? "")+")"
                }else{
                    movieTitleLable.text = "Movie"
                }
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: data.posterURL).sink { err in
                } receiveValue: { [weak self] image in
                    UIView.transition(with: self?.posterImage ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                        self?.posterImage.image = image
                    }, completion: nil)
                }.store(in: &subscriptions)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()                
    }
    override func layoutSubviews() {
        setupView()
    }
    func setupView(){
        containerView.layer.borderWidth = 0.3
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
    }
}
