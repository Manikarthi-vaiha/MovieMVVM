//
//  MovieCastCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/1/22.
//

import UIKit

class MovieCastCell: UITableViewCell {
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var seeAllBtnLabel: UILabel!
    
    var completion: ((_ data: MovieCast?) ->())?
    var detail: MovieDetailModel! {
        didSet {
            setupUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(){
        seeAllBtnLabel.isUserInteractionEnabled = true
        castCollectionView.registerNib(nib: CastCollectionCell.reuseIdentifier)
        castCollectionView.setCollectionViewFlowLayout(CGSize(width: 100, height: self.castCollectionView.frame.height), true)
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
    }

}


extension MovieCastCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(detail.credits?.cast[indexPath.row])
    }
}

extension MovieCastCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detail.credits?.cast.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CastCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.url = detail.credits?.cast[indexPath.row].profileURL
        return cell
    }
}
