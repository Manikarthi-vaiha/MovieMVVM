//
//  UICollectionViewCell+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation
import UIKit


extension UICollectionViewCell {
    // Type Level
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func showAnimation(){
        alpha = 0.0
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}
