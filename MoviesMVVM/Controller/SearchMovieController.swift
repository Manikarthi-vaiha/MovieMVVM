//
//  SearchMovieController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/6/22.
//

import UIKit
import Combine

enum MovieDetailsType {
    case SearchMovie
    case Keywords
}

typealias FindMovieList = MovieDetailsType

class SearchMovieController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchMovieTable: UITableView!
    @IBOutlet weak var searchBarConstraint:NSLayoutConstraint!
    
    private lazy var bindings = Set<AnyCancellable>()
    var findMovieList: FindMovieList = .SearchMovie
    var viewModel: SearchMovieViewModel!
    var keyWordID: String?
    var keywordName: String?
    var waiting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = keywordName
        searchMovieTable.keyboardDismissMode = .onDrag
        searchMovieTable.dataSource = self
        searchMovieTable.delegate = self
        searchBar.delegate = self
        searchBar.endEditing(true)
        searchBar.searchTextField.textPublisher.sink { completion in
        } receiveValue: { [weak self] searchText in
            guard let self = `self` else { return }
            self.viewModel.reset()
            if !searchText.isEmpty {
                self.viewModel.getSearchItem(text: searchText, page: self.viewModel.pageNumber)
            }else{
                self.viewModel.reset()
                self.searchMovieTable.reloadData()
                self.searchMovieTable.setEmptyMessage("No data Found")
            }
        }.store(in: &bindings)
        viewModel = SearchMovieViewModel()
        
        viewModel.$searchModel
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
            })
            .store(in: &bindings)
        
        let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.searchMovieTable.restore()
                self.searchMovieTable.showActivityIndicator()
                break
            case .finishedLoading:
                if (self.viewModel.searchModel.count > 0) {
                    self.searchMovieTable.hideActivityIndicator()
                }else{
                    self.viewModel.reset()
                    self.searchMovieTable.reloadData()
                    self.searchMovieTable.setEmptyMessage("No data Found")
                }
                self.waiting = false
                self.searchMovieTable.reloadData()
                break
            case .error(let error):
                self.viewModel.reset()
                self.searchMovieTable.setEmptyMessage(error.localizedDescription)
                self.searchMovieTable.reloadData()
                break
            case .none:
                break
            }
        }
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
        
        switch findMovieList {
        case .SearchMovie:
            searchBar.searchTextField.becomeFirstResponder()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        case .Keywords:
            searchBarConstraint.constant = 0
            viewModel.getKeyworrdMovieList(for: keyWordID,page: viewModel.pageNumber)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            setupFilterBtn()
            searchBar.alpha = 0.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch findMovieList {
        case .SearchMovie:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        case .Keywords:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.navigationController?.navigationSetup()
    }
    
    func setupFilterBtn(){
        filterBtn.menu = createContextMenu()
        let btn = UIBarButtonItem(customView: filterBtn)
        btn.customView?.translatesAutoresizingMaskIntoConstraints = false
        btn.customView?.translatesAutoresizingMaskIntoConstraints = false
        btn.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        btn.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = btn
    }
    
    private func createContextMenu() -> UIMenu {
        let decending = UIAction(title: "Ascending", image: nil, state: .on) { (_) in
            //decending
        }
        let acending = UIAction(title: "Dscending", image: nil) { (_) in
            //acending
        }
        let popularity = UIAction(title: "Popularity", image: UIImage(systemName: "person.fill.checkmark.rtl"),state: .on) { (_) in
            // delete item
        }
        let ratings = UIAction(title: "Rating", image: UIImage(systemName: "star")) { (_) in
            // handle refresh
        }
        let releaseData = UIAction(title: "Release date", image: UIImage(systemName: "calendar.circle")) { (_) in
            // handle refresh
        }
        let submenu = UIMenu(title: "",options: .displayInline, children: [decending, acending])
        return UIMenu(title: "Options",options: .displayInline, children: [popularity, ratings,releaseData, submenu])
    }
    
    @objc private func generateFilterMenu() {
        filterBtn.menu = createContextMenu()
    }
    private lazy var filterBtn: UIButton = {
        $0.setImage(UIImage(named: "fillterIcon"), for: .normal)
        $0.addTarget(self, action: #selector(generateFilterMenu), for: .menuActionTriggered)
        $0.showsMenuAsPrimaryAction = true
        return $0
    }(UIButton(type: .system))
}

extension SearchMovieController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        NotificationCenter.default.post(name: .isShowNavigationController, object: nil)
        self.remove(self)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let searchText = searchBar.searchTextField.text, !searchText.isEmpty else {
            self.viewModel.reset()
            self.searchMovieTable.reloadData()
            self.navigationController?.remove(self)
            return
        }
    }
}

extension SearchMovieController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension SearchMovieController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieSearchCell = tableView.dequeueReusableCell(for: indexPath)
        cell.data = viewModel.searchModel[safe: indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel.searchModel[safe: indexPath.row], let id = data.id {
            if let controller = self.getController(controller: MovieDetailViewController()) as? MovieDetailViewController {
                controller.movieID = "\(id)"
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = viewModel.searchModel.count
        if viewModel.totalPage == viewModel.pageNumber {
            return
        }
        if indexPath.row == count-1 && !self.waiting  {
            waiting = true;
            self.loadMoreData()
        }
        cell.showAnimation()
    }
    func loadMoreData(){
        viewModel.pageNumber += 1
        switch findMovieList {
        case .SearchMovie:
            viewModel.getSearchItem(text: searchBar.text, page: viewModel.pageNumber)
            break
        case .Keywords:
            viewModel.getKeyworrdMovieList(for: keyWordID, page: viewModel.pageNumber)
        }
    }
}
