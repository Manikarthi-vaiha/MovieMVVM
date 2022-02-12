//
//  UINavigationViewController+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/9/22.
//

import Foundation
import UIKit

extension UINavigationController {
    func navigationSetup() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationBar.backgroundColor = .clear
    }
    func navigationHideBackButton(){
        navigationBar.tintColor = .white
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}
