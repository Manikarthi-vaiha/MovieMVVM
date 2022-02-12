//
//  CompanyCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit

class CompanyCell: UITableViewCell {

    @IBOutlet weak var companyCollectionView: UICollectionView!
    var completion: ((_ data: ProductionCompany?) ->())?

    var data: [ProductionCompany]? {
        didSet{
            setupUI()
        }
    }
    func setupUI(){
        companyCollectionView.registerNib(nib: CompanyNameCell.reuseIdentifier)
        companyCollectionView.setCollectionViewFlowLayout()
        companyCollectionView.delegate = self
        companyCollectionView.dataSource = self
        companyCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        setupUI()
    }
}


extension CompanyCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(data?[indexPath.row])
    }
}

extension CompanyCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CompanyNameCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.name = data?[indexPath.row].name
        return cell
    }
}

