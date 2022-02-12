//
//  UICollectionViewFlowLayout.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func setCollectionViewFlowLayout(_ itemSize: CGSize = .zero,_ isEnableItem: Bool = false){
        let layout = UICollectionViewFlowLayout()
        if isEnableItem {
            layout.itemSize = itemSize
        }else{
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        layout.scrollDirection         = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing      = 10
        self.collectionViewLayout = layout
    }
}

