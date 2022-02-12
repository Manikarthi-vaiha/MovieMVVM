//
//  ViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 1/28/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    var viewModel: HomePageViewModel!
    @Published private(set) var state: ListViewModelState = .loading
    var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    var waiting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentController()
        setupCollctionView()
        viewModel = HomePageViewModel()
        viewModel.getAPiResponse(page: viewModel.pageNumber)
        
        self.movieCollectionView.delegate = self
        self.movieCollectionView.dataSource = self
        
        viewModel.$trendingModel
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
            })
            .store(in: &bindings)
        
        let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.movieCollectionView.restore()
                self.view.activityStartAnimating(activityColor: .white, backgroundColor: .black)
                break
            case .finishedLoading:
                if (self.viewModel.trendingModel.count > 0) {
                    self.view.activityStopAnimating()
                }else{
                    self.view.activityStopAnimating()
                    self.movieCollectionView.setEmptyMessage("No data Found")
                }
                self.waiting = false
                self.movieCollectionView.reloadData()
                break
            case .error(let error):
                self.view.activityStopAnimating()
                self.movieCollectionView.setEmptyMessage(error.localizedDescription)
                self.movieCollectionView.reloadData()
                break
            case .none:
                break
            }
        }
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
        
        setupMenuGestureRecognizer(self)
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        NotificationCenter.default.addObserver(forName: .reloadNotifier, object: nil, queue: .main) { [weak self] notify in
            guard let self = self else { return }
            self.view.activityStartAnimating(activityColor: .white, backgroundColor: .black)
            self.viewModel.resetData()
            self.viewModel.getAPiResponse(page: self.viewModel.pageNumber)
        }
        NotificationCenter.default.addObserver(forName: .isShowNavigationController, object: nil, queue: .main) { _ in
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @IBAction func searchBarButtonAction(_ sender: UIBarButtonItem) {
        if let searchController = self.getController(controller: SearchMovieController()) as? SearchMovieController {
            searchController.findMovieList = .SearchMovie
            add(searchController)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupSegmentController(){
        let segment: UISegmentedControl = UISegmentedControl(items: ["Now Playing", "Popular","Upcoming"])
        segment.sizeToFit()
        if #available(iOS 13.0, *) {
            segment.selectedSegmentTintColor = UIColor.red
        } else {
            segment.tintColor = UIColor.red
        }
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(self.changeIndex(_:)), for: .valueChanged)
        self.navigationItem.titleView = segment
    }
    
    @objc func changeIndex(_ segment: UISegmentedControl){
        switch segment.selectedSegmentIndex {
        case 0 :
            viewModel.movieType = .now_playing
        case 1 :
            viewModel.movieType = .popular
        case 2 :
            viewModel.movieType = .upcoming
        default :
            viewModel.movieType = .now_playing
            break
        }
        viewModel.resetData()
        movieCollectionView.performBatchUpdates {
        } completion: { _ in
        }
        movieCollectionView.setContentOffset(.zero, animated: false)
        viewModel.getAPiResponse(page: viewModel.pageNumber)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor =  .clear
    }
    
    func setupCollctionView(){
        movieCollectionView.collectionViewLayout = getCompositionalLayout()
        movieCollectionView.registerNib(nib: MoviePosterCell.reuseIdentifier)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.trendingModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MoviePosterCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.data = viewModel.trendingModel[safe:indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.trendingModel[indexPath.row]
        if let id = data.id {
            if let controller = self.getController(controller: MovieDetailViewController()) as? MovieDetailViewController {
                controller.movieID = "\(id)"
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = viewModel.trendingModel.count
        if viewModel.totalPage == viewModel.pageNumber {
            return
        }
        if indexPath.row == count-1 && !self.waiting  {
            waiting = true;
            self.loadMoreData()
        }
        if self.waiting {
            cell.showAnimation()
        }
    }
    
    func loadMoreData(){
        viewModel.pageNumber += 1
        viewModel.getAPiResponse(page: viewModel.pageNumber)
    }
}



