//
//  ChooseLanguageCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit

class ChooseLanguageCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var checkMarkImage:UIImageView!
    
    var LangName: String? {
        didSet {
            langLabel.text = LangName
        }
    }
    override func layoutSubviews() {
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
    }
    
}
