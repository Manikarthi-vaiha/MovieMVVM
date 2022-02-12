//
//  ImageCache.swift
//  MoviesMVVM
//
//  Created by Mani on 2/9/22.
//

import Foundation
import UIKit

class ImageCache:NSObject {
    
    private override init() {
    }
    static let shared = ImageCache()
    let cache = NSCache<NSURL, UIImage>()
}
