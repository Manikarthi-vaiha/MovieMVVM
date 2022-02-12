//
//  UILabel+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/1/22.
//

import Foundation
import UIKit

extension UILabel {
    func animatedText(for text: String?){
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.text = text ?? ""
        }, completion: nil)
    }
    
    func animatedTextWithTitle(title name: String, for text: String?){
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            if (text?.isEmpty ?? true) {
                self.text = ""
            }else{
                let headerAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
                let subtitleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                let header = NSMutableAttributedString(attributedString: NSAttributedString(string: name, attributes: headerAttribute))
                header.append(NSAttributedString(string: (text ?? ""), attributes: subtitleAttribute))
                self.attributedText = header
            }
        }, completion: nil)
    }
    
    func makeLink(title name: String, for text: String?){
        if (text?.isEmpty ?? true) {
            self.text = ""
        }else{
            let headerAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
            let subtitleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.link: text ?? "",
                                     NSAttributedString.Key.foregroundColor: UIColor.green
            ] as [NSAttributedString.Key : Any]
            let header = NSMutableAttributedString(attributedString: NSAttributedString(string: name, attributes: headerAttribute))
            header.append(NSAttributedString(string: (text ?? ""), attributes: subtitleAttribute))
            self.attributedText = header
        }
    }
}
