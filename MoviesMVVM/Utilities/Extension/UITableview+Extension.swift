//
//  UITableview+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation
import UIKit


protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView: ReusableView {
    func registerNib(nib nibName: String){
        let nib = UINib(nibName: nibName, bundle: .main)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                let activityView = UIActivityIndicatorView(style: .medium)
                self.backgroundView = activityView
                activityView.color = UIColor(named: "#9E58FC")
                activityView.startAnimating()
            } else {
                let activityView = UIActivityIndicatorView.init(style: .white)
                activityView.color = UIColor(hex: "#9E58FC")
                self.backgroundView = activityView
                activityView.startAnimating()
            }
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}




