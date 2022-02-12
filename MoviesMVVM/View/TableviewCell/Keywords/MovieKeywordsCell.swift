//
//  KeywordsTableCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import UIKit

class MovieKeywordsCell: UITableViewCell {

    @IBOutlet weak var keywordCollectionView: UICollectionView!
    var completion: ((_ data: keywordsData?) ->())?
    var detail: KeywordsModel! {
        didSet {
            setupUI()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(){
        keywordCollectionView.registerNib(nib: KeywordsCollectionCell.reuseIdentifier)
        keywordCollectionView.setCollectionViewFlowLayout()
        keywordCollectionView.delegate = self
        keywordCollectionView.dataSource = self
        keywordCollectionView.reloadData()
    }
    
}


extension MovieKeywordsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(detail.keywords?[indexPath.row])
    }
}

extension MovieKeywordsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detail.keywords?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:KeywordsCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.name = detail.keywords?[indexPath.row].name
        return cell
    }
}
