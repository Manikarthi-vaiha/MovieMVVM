//
//  KeywordsCollectionCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import UIKit

class KeywordsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel:UILabel!
    var name: String? {
        didSet {
            containerView.layer.cornerRadius = 10
            containerView.layer.masksToBounds = true
            nameLabel.text = name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
