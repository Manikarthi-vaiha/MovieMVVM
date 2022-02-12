//
//  UICollectionView+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation
import UIKit

extension UICollectionView: ReusableView {
    func registerNib(nib nibName: String){
        let nib = UINib(nibName: nibName, bundle: .main)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
    
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        UIView.transition(with: messageLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            messageLabel.text = message
                          }, completion: nil)
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
//        messageLabel.font = UIFont(name: "SFUIText-Medium", size: 20)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
