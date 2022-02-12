//
//  CollectionsViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    @IBOutlet weak var collectionTable: UITableView!
    var collections: MovieCollectionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
    }
    
    func setupTableview(){
        self.title = "Collections"
        collectionTable.registerNib(nib: CollectionPartsCell.reuseIdentifier)
        collectionTable.register(UINib(nibName: "CollectionHeaderCell", bundle: .main), forHeaderFooterViewReuseIdentifier: "CollectionHeaderCell")
        collectionTable.delegate = self
        collectionTable.dataSource = self
        collectionTable.reloadData()
    }
}

extension CollectionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width * 0.6
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.width * 0.55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = self.getController(controller: MovieDetailViewController()) as? MovieDetailViewController, let id = collections?.parts?[safe: indexPath.row]?.id {
            controller.movieID = "\(id)"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension CollectionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections?.parts?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollectionPartsCell = tableView.dequeueReusableCell(for: indexPath)
        cell.data = collections?.parts?[safe: indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CollectionHeaderCell") as? CollectionHeaderCell {
            cell.data = collections
            return cell
        }
        return nil
    }
    
}
