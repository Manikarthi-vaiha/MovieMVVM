//
//  Notification+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/5/22.
//

import Foundation


extension Notification.Name {
    static var reloadNotifier: Notification.Name {
        return .init(rawValue: "Reloading data")
    }
    
    static var isShowNavigationController: Notification.Name {
        return .init(rawValue: "HomeNavigationController")
    }
}



