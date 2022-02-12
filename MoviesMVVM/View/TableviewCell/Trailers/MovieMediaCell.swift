//
//  MovieMediaCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import UIKit
import SafariServices


class MovieMediaCell: UITableViewCell {
    
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var trailerViewCollectionViewL: UICollectionView!
    
    var movieResponse: [MovieVideo]?{
        didSet{
            titileLabel.text = "Videos"
            setupUI()
        }
    }
    
    var completion: ((_ data: String) ->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(){
        trailerViewCollectionViewL.setCollectionViewFlowLayout(CGSize(width: self.frame.width/2, height: trailerViewCollectionViewL.frame.size.height), true)
        trailerViewCollectionViewL.registerNib(nib: TrailerColleciontCell.reuseIdentifier)
        trailerViewCollectionViewL.delegate = self
        trailerViewCollectionViewL.dataSource = self        
        trailerViewCollectionViewL.reloadData()
    }
}


extension MovieMediaCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let videoURL = movieResponse?[indexPath.row].key {
            completion?(videoURL)            
        }
    }
}

extension MovieMediaCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResponse?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TrailerColleciontCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.response = movieResponse?[indexPath.row]
        return cell
    }
}
