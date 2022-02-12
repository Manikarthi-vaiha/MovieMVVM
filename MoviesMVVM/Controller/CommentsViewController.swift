//
//  CommentsViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/9/22.
//

import UIKit
import CoreMedia


enum ReviewData {
    case All(list: [ReviewResult]?, index: Int?)
}

typealias ReviewType = ReviewData

extension CommentsViewController {
    enum Section {
        case main
    }
}

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var reviewList: [ReviewResult]? = nil
    var reviewType: ReviewType?
    var defaultCellHeight: CGFloat {
        return view.frame.size.width * 0.5
    }
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(nib: ReviewTableCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "All Reviews"
        
        switch reviewType {
        case .All(list: let list, let index):
            reviewList = list
            tableView.reloadData()
            if let index = index {
//                self.tableView.scrollToBottom(animated: true)
            }
        case .none:
            break
        }
    }
}


extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = selectedIndexPath == indexPath ? nil : indexPath
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewTableCell  = tableView.dequeueReusableCell(for: indexPath)
        if let index = selectedIndexPath, index == indexPath {
            cell.overviewLabel.numberOfLines = 0
        }else{
            cell.overviewLabel.numberOfLines = 5
        }
        cell.data = reviewList?[safe: indexPath.row]
        return cell
    }
    
}
