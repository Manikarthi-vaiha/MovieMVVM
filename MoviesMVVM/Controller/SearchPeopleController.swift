//
//  SearchPeopleController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/11/22.
//

import UIKit
import Combine

class SearchPeopleController: UIViewController {
    
    @IBOutlet weak var searchPersonTableView:UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    var searchPeopleList: [SearchPeopleResult] = []
    var viewModel: SearchPeopleViewModel!
    var waiting = false
       
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        searchPersonTableView.keyboardDismissMode = .onDrag
        searchPersonTableView.delegate = self
        searchPersonTableView.dataSource = self
        setupSearchBar()
               
        viewModel = SearchPeopleViewModel()
        viewModel.$searchModel
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
            })
            .store(in: &binding)
        
        let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.searchPersonTableView.restore()
                self.searchPersonTableView.showActivityIndicator()
                break
            case .finishedLoading:
                if (self.viewModel.searchModel.count > 0) {
                    self.searchPersonTableView.hideActivityIndicator()
                }else{
                    self.viewModel.reset()
                    self.searchPersonTableView.reloadData()
                    self.searchPersonTableView.setEmptyMessage("No data Found")
                }
                self.waiting = false
                self.searchPersonTableView.reloadData()
                break
            case .error(let error):
                self.viewModel.reset()
                self.searchPersonTableView.setEmptyMessage(error.localizedDescription)
                self.searchPersonTableView.reloadData()
                break
            case .none:
                break
            }
        }
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &binding)
        
    }
    
    func setupSearchBar(){
        searchBar.searchTextField.textPublisher.sink { completion in
        } receiveValue: { searchText in
            self.viewModel.reset()
            if !searchText.isEmpty {
                self.viewModel.getSearchPeople(text: searchText, page: self.viewModel.pageNumber)
            }else{
                self.viewModel.reset()
                self.searchPersonTableView.reloadData()
                self.searchPersonTableView.setEmptyMessage("No data Found")
            }
        }.store(in: &binding)
    }
    
    func setupData(){
        searchPersonTableView.registerNib(nib: AllCastCell.reuseIdentifier)
        searchPersonTableView.delegate = self
        searchPersonTableView.backgroundColor = UIColor.clear
    }
}


extension SearchPeopleController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PeopleTableCell = tableView.dequeueReusableCell(for: indexPath)
        cell.data = viewModel.searchModel[safe: indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel.searchModel[safe: indexPath.row], let id = data.id {
            let controller = self.getController(controller: MovieCastViewController()) as? MovieCastViewController
            controller?.personID = "\(id)"
            self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        viewModel.getSearchPeople(text: searchBar.text, page: 1)
    }
}
