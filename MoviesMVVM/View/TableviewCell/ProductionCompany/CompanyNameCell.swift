//
//  CompanyNameCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit

class CompanyNameCell: UICollectionViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var container: UIView!

    var name: String? {
        didSet {
            container.layer.cornerRadius = 10
            container.layer.masksToBounds = true
            companyNameLabel.text = name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
