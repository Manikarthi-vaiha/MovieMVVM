//
//  UITapGestureRecognizer+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation
import UIKit

class ClickListener: UITapGestureRecognizer {
    var onClick : (([String:Any]?) -> Void)?
    var userInfo: [String:Any]?
    
    init(target: Any?, action: Selector?, userInfo: [String:Any]? = nil, onClick: (([String:Any]?) -> Void)?) {
        self.userInfo = userInfo
        self.onClick = onClick
        super.init(target: target, action: action)
    }
}

extension UIView {
    
    func setOnClickListener(userInfo: [String:Any], action :@escaping ([String:Any]?) -> Void){
        self.isUserInteractionEnabled = true
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked), userInfo: userInfo, onClick: action)
        self.addGestureRecognizer(tapRecogniser)
    }
    
    @objc func onViewClicked(_ sender: ClickListener) {
        sender.onClick?(sender.userInfo)
    }
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)

        self.addSubview(backgroundView)
    }

    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    
}

