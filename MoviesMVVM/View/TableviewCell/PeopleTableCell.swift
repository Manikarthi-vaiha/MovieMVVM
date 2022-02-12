//
//  PeopleTableCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/12/22.
//

import UIKit
import Combine

class PeopleTableCell: UITableViewCell {

    @IBOutlet weak var personImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    private lazy var bindings = Set<AnyCancellable>()
    
    var data: SearchPeopleResult? {
        didSet {
            nameLabel.text = data?.name
            if let poster = data?.profileURL {
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: poster).sink { err in
                } receiveValue: { [weak self] image in
                    UIView.transition(with: self?.personImageView ?? UIView(), duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                        guard let self = self else { return }
                        self.personImageView.image = image
                    }, completion: nil)
                }.store(in: &bindings)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
