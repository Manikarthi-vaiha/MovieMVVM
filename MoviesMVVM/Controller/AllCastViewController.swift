//
//  AllCastViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/9/22.
//

import UIKit
import Combine


class AllCastViewController: UIViewController {
    
    @IBOutlet weak var castTableView: UITableView!
    private lazy var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    typealias DataSource = UITableViewDiffableDataSource<Int, MovieCast>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MovieCast>
    var castList: [MovieCast]?
    var orignalList: [MovieCast]?
    var movieName: String?
    lazy var dataSource = makeDataSource()
    lazy var searchBar:UISearchBar = UISearchBar()
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: castTableView, cellProvider: {( tableView, indexPath, cast) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: AllCastCell.reuseIdentifier, for: indexPath) as? AllCastCell
            cell?.data = cast
            return cell
        })
        return dataSource
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        castTableView.keyboardDismissMode = .onDrag
        castTableView.delegate = self
        setupData()
        setupNavigation()
    }
    func setupNavigation(){
        self.title = "All Cast"
        self.navigationController?.navigationSetup()
    }    
    
    func setupData(){
         castList = orignalList
        castTableView.registerNib(nib: AllCastCell.reuseIdentifier)
        castTableView.delegate = self
        castTableView.backgroundColor = UIColor.clear
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(castList ?? [] , toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension AllCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 70))
        view.backgroundColor = .clear
        let movieNameLabel = UILabel()
        movieNameLabel.text = movieName
        movieNameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        movieNameLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(movieNameLabel)
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            movieNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10),
            movieNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
                
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .clear
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            searchBar.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 5),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        let countLable = UILabel()
        countLable.text = "\(castList?.count ?? 0) People"
        countLable.font = .systemFont(ofSize: 15, weight: .medium)
        countLable.textColor = UIColor.white.withAlphaComponent(0.9)
        view.addSubview(countLable)
        countLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            countLable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            countLable.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            countLable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        searchBar.searchTextField.textPublisher.sink { completion in
        } receiveValue: { searchText in
            self.castList = self.orignalList?.filter({ respo in
                if respo.name?.uppercased().contains(searchText.uppercased()) ?? false {
                   return true
                }else if respo.character?.uppercased().contains(searchText.uppercased()) ?? false {
                    return true
                }else{
                    return false
                }
            })
            guard let text = self.searchBar.searchTextField.text else {
                return
            }
            if (!text.isEmpty && self.castList?.isEmpty ?? false) {
                self.castTableView.setEmptyMessage("No Language Detected")
            }else{
                if text.isEmpty {
                    self.castList = self.orignalList
                }
                self.castTableView.restore()
            }
            countLable.animatedText(for: "\(self.castList?.count ?? 0) People")
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(self.castList ?? [], toSection: 0)
            self.dataSource.apply(snapshot)
            self.castTableView.reloadData()
        }.store(in: &binding)
        
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = self.getController(controller: MovieCastViewController()) as? MovieCastViewController
        if let id = castList?[safe: indexPath.row]?.id {
            controller?.personID = "\(id)"
        }
        self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
    }
}
