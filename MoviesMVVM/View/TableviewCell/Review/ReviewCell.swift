//
//  ReviewCell.swift
//  MoviesMVVM
//
//  Created by Mani on 1/31/22.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var seeAllBtnLabel: UILabel!
    
    var completion: ((_ data: ReviewResult?) ->())?
    var results: [ReviewResult]? {
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
        reviewCollectionView.registerNib(nib: ReviewCollectionViewCell.reuseIdentifier)
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.setCollectionViewFlowLayout(CGSize(width: reviewCollectionView.frame.width, height: reviewCollectionView.frame.height), true)
        reviewCollectionView.reloadData()
    }
    
}

extension ReviewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.data = results?[indexPath.row]
        return cell
    }
}

extension ReviewCell: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(results?[indexPath.row])
    }
}
