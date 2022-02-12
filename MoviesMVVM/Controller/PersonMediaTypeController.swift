//
//  PersonMediaTypeController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import UIKit
import Combine

class PersonMediaTypeController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movieCastResponse: MovieCastPassionModel?
    typealias DataSource = UITableViewDiffableDataSource<String, PassionCast>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, PassionCast>
    private lazy var modelData: [String : [PassionCast]] = [:]
    private lazy var dataSource = makeDataSource()
    private lazy var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    var url: URL?
    var castName: String?
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView, cellProvider: {( tableView, indexPath, contact) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCastKnownAsCell.reuseIdentifier, for: indexPath) as? MovieCastKnownAsCell
            cell?.data = contact
            return cell
        })
        return dataSource
    }
    
    func updateArray() {        
        if var mod = movieCastResponse?.crew {
            mod.sort(){ $0.releaseDateWithFormat > $1.releaseDateWithFormat}
            modelData = Dictionary(grouping: mod) { res in
                return res.department ?? ""
            }
        }
        if var mod = movieCastResponse?.cast {
            mod.sort(){ $0.releaseDateWithFormat > $1.releaseDateWithFormat}
            movieCastResponse?.cast = mod
        }
        modelData.updateValue((movieCastResponse?.cast ?? []), forKey: "Acting")
        tableView.registerNib(nib: MovieCastKnownAsCell.reuseIdentifier)
        tableView.register(SectionHeaderReusableView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        var snapshot = Snapshot()
        snapshot.appendSections( modelData.map { $0.key } )
        modelData.forEach { repos in
            snapshot.appendItems(repos.value, toSection: repos.key)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = castName    
        updateArray()
        self.navigationController?.navigationSetup()
    }
    override func viewDidLayoutSubviews() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}


extension PersonMediaTypeController {
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SectionHeaderReusableView.reuseIdentifier) as? SectionHeaderReusableView
        else {
            return nil
        }
        let keys = modelData.map( { $0.key  } )
        header.titleLabel.text = keys[section]
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = "\(Array(modelData)[indexPath.section].value[indexPath.row].id ?? 0)"
        let controller = self.getController(controller: MovieDetailViewController()) as? MovieDetailViewController
        controller?.movieID = id
        self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
    }
}


extension PersonMediaTypeController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

