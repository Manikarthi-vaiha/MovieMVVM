//
//  UIDate+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/4/22.
//

import Foundation
import UIKit


extension String {
    func getDate(formate type:String, to formate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type
        if let date = dateFormatter.date(from: self) {
            let dateFor = DateFormatter()
            dateFor.dateFormat = formate
            return dateFor.string(from: date)
        }
        return nil
    }
}
