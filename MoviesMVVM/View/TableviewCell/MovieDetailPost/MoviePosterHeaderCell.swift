//
//  MoviePosterHeaderCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import UIKit
import Combine

class MoviePosterHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var gradiantContainer: UIView!
    @IBOutlet weak var textData: UILabel!
    
    var gradientLayer: CAGradientLayer?
    var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    var completionColor: ((_ data: UIColor,_ image: UIImage)->())?
    
    var data: MovieDetailModel?{
        didSet {
            var text = ""
            if let date = data?.releaseDateText, !date.isEmpty {
                text = date
            }
            if let rating = data?.voteAverage {
                text += " | ⭐️ " + "\(rating)"
            }
            if let runtime = data?.runTimeString {
                text += " | " + runtime
            }
            textData.text = text
            if let poster = data?.backdropURL {
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: poster).sink { err in
                } receiveValue: { [weak self] image in
                    UIView.transition(with: self?.postImageView ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                        guard let self = self else { return }
                        self.postImageView.image = image
                        self.completionColor?(image.getPixelColor(pos:CGPoint(x: 2, y: 2)), image)
                    }, completion: nil)
                }.store(in: &bindings)
            }
        }
    }
        
    override func layoutSubviews() {
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]            
            gradientLayer?.frame.size = gradiantContainer.frame.size
            gradiantContainer?.layer.insertSublayer(gradientLayer! , at: 0)
        }
    }
    
}


extension CAGradientLayer {
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}
