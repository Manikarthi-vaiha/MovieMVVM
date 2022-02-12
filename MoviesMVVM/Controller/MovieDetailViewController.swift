//
//  MovieDetailViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 1/30/22.
//

import UIKit
import Combine
import SafariServices

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieTable: UITableView!    
    var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    private var viewModel: MovieDetailViewModel!
    var movieID: String?
    private var subscriptions = Set<AnyCancellable>()
    var dimView:UIView?
    var player: YTPlayerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setupNavigationBarButton()
        viewModel = MovieDetailViewModel(model: HTTPClient())
        viewModel.getAPiResponse(id: movieID ?? "")
        getApiData()
    }
        
    override func viewDidLayoutSubviews() {
        navigationController?.navigationHideBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationSetup()
    }
    
    func setupStatusBar(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    func setupNavigationBarButton(){
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.layer.masksToBounds = true
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButton.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        barButton.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return  }
            let controller = self.getController(controller: MovieImagesViewController()) as? MovieImagesViewController
            controller?.id = self.movieID
            self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
        }), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func getApiData(){
        let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.view.activityStartAnimating(activityColor: .white, backgroundColor: .black)
                break
            case .finishedLoading:
                self.setupTableview()
                if let title = self.viewModel.movieDetail?.detail.title {
                    self.title = title
                }
                self.viewModel.$collections
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { _ in
                        self.view.activityStopAnimating()
                    }, receiveValue: { repo in
                        self.view.activityStopAnimating()
                        self.movieTable.reloadData()
                    }).store(in: &self.bindings)
                self.movieTable.reloadData()
                break
            case .error(let error):
                self.view.activityStopAnimating()
                TTGSnackbar(message: error.localizedDescription, duration: .middle).show()
                break
            case .none:
                break
            }
        }
        viewModel.$movieDetail
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
            }).store(in: &bindings)
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
    }
    
    func setupTableview(){
        movieTable.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        movieTable.register(UINib(nibName: "MoviePosterHeaderCell", bundle: .main), forHeaderFooterViewReuseIdentifier: "MoviePosterHeaderCell")
        movieTable.registerNib(nib: CompanyCell.reuseIdentifier)
        movieTable.registerNib(nib: MovieDetailCell.reuseIdentifier)
        movieTable.registerNib(nib: MovieCastCell.reuseIdentifier)
        movieTable.registerNib(nib: ReviewCell.reuseIdentifier)
        movieTable.registerNib(nib: MoviesCollectionCell.reuseIdentifier)
        movieTable.registerNib(nib: MovieMediaCell.reuseIdentifier)
        movieTable.registerNib(nib: MovieKeywordsCell.reuseIdentifier)
        movieTable.delegate = self
        movieTable.dataSource = self
    }
    
}

extension MovieDetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.movieSection[section] == .MovieDetail ? 200 : 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.showAnimation()
    }
}

extension MovieDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.movieSection.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.movieSection[section] {
        case .MovieDetail,.MovieCast,.MovieReview,.MoviewCollection,.Media,.MovieRecommadation,.MovieKeywords, .ProductionCompany:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.movieSection[indexPath.section] {
        case .MovieDetail:
            let cell: MovieDetailCell = tableView.dequeueReusableCell(for: indexPath)
            cell.detail = self.viewModel.movieDetail?.detail
            return cell
        case .ProductionCompany:
            let cell: CompanyCell = tableView.dequeueReusableCell(for: indexPath)
            cell.data = self.viewModel.movieDetail?.detail.productionCompanies
            cell.completion = { company in
                if let controller = self.getController(controller: CompanyDetailsController()) as? CompanyDetailsController {
                    controller.companyID = "\(company?.id ?? 0)"
                    controller.companyName = company?.name
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            return cell
        case .MovieCast:
            let cell: MovieCastCell = tableView.dequeueReusableCell(for: indexPath)
            cell.detail = self.viewModel.movieDetail?.detail
            cell.seeAllBtnLabel.setOnClickListener(userInfo: [:]) { [weak self] _ in
                guard let self = self else { return }
                let controller = self.getController(controller: AllCastViewController()) as? AllCastViewController
                if let title = self.viewModel.movieDetail?.detail.title, let date = self.viewModel.movieDetail?.detail.releaseDateText, !date.isEmpty {
                    controller?.movieName = title + " (\(date))"
                }else{
                    controller?.movieName = ""
                }
                controller?.orignalList = self.viewModel.movieDetail?.detail.credits?.cast
                self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
            }
            cell.completion = { [weak self] response in
                guard let self = self else { return }
                let controller = self.getController(controller: MovieCastViewController()) as? MovieCastViewController
                controller?.personID = "\(response?.id ?? 0)"
                self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
            }
            return cell
        case .MovieReview:
            let cell: ReviewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.results = self.viewModel.movieDetail?.review.results
            cell.seeAllBtnLabel.setOnClickListener(userInfo: [:]) { [weak self] _ in
                guard let self = self else { return  }
                if let commentController = self.getController(controller: CommentsViewController()) as? CommentsViewController {
                    commentController.reviewType = .All(list: self.viewModel.movieDetail?.review.results,index: nil)
                    self.navigationController?.pushViewController(commentController, animated: true)
                }
            }
            cell.completion = { [weak self] respo in
                guard let self = self else { return  }
                if let commentController = self.getController(controller: CommentsViewController()) as? CommentsViewController {
                    commentController.reviewType = .All(list: self.viewModel.movieDetail?.review.results,index: indexPath.row)
                    self.navigationController?.pushViewController(commentController, animated: true)
                }
            }
            return cell
        case .MoviewCollection:
            let cell: MoviesCollectionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.data = self.viewModel.collections
            cell.setOnClickListener(userInfo: [:]) { _ in
                if let collectionController = self.getController(controller: CollectionsViewController()) as? CollectionsViewController {
                    collectionController.collections = self.viewModel.collections
                    self.navigationController?.pushViewController(collectionController, animated: true)
                }
            }
            return cell
        case .Media:
            let cell: MovieMediaCell = tableView.dequeueReusableCell(for: indexPath)
            cell.movieResponse = self.viewModel.movieDetail?.video.results
            cell.completion = { url in
                self.youtubePlayer(playWithURL: url)
            }
            return cell
        case .MovieKeywords:
            let cell: MovieKeywordsCell = tableView.dequeueReusableCell(for: indexPath)
            cell.detail = viewModel.keywords
            cell.completion = { [weak self] model in
                guard let self = self else { return  }
                if let searchController = self.getController(controller: SearchMovieController()) as? SearchMovieController {
                    searchController.findMovieList = .Keywords
                    if let id = model?.id, let keywordName = model?.name {
                        searchController.keywordName = keywordName
                        searchController.keyWordID = "\(id)"
                    }
                    self.navigationController?.pushViewController(searchController, animated: true)
                }
            }
            return cell
        case .MovieRecommadation:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.movieSection[section] == .MovieDetail {
            if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MoviePosterHeaderCell") as? MoviePosterHeaderCell {
                cell.data = viewModel.movieDetail?.detail
                cell.completionColor = { [weak self] color, image in
                    guard let self = self else { return }
                    cell.isUserInteractionEnabled = true
                    cell.setOnClickListener(userInfo: [:]) { res in
                        let imageInfo      = GSImageInfo(image: image, imageMode: .aspectFit)
                        let transitionInfo = GSTransitionInfo(fromView: cell)
                        let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                        self.present(imageViewer, animated: true, completion: nil)
                    }
                }
                return cell
            }
            return nil
        }
        return nil
    }
    
    
    func youtubePlayer(playWithURL url: String){
        dimView = UIView(frame: UIScreen.main.bounds)
        dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.navigationController?.view.addSubview(dimView ?? UIView())
        player = YTPlayerView(frame: .zero)
        player?.backgroundColor = .clear
        dimView?.addSubview(player ?? UIView())
        self.view.bringSubviewToFront(player ?? UIView())
        player?.translatesAutoresizingMaskIntoConstraints = false
        player?.load(withVideoId: url, playerVars: ["controls" : 1,"playsinline" : 1,"autohide" : 1,"showinfo" : 0,"modestbranding" : 1])
        player?.delegate = self
        if let player = self.player {
            NSLayoutConstraint.activate([
                player.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.7),
                player.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                player.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                player.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                player.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        }
        dimView?.setOnClickListener(userInfo: [:], action: { _ in
            UIView.animate(withDuration: 0.25, animations: {
                self.dimView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.dimView?.alpha = 0.0;
                self.player?.alpha = 0.0
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.player?.removeFromSuperview()
                    self.dimView?.removeFromSuperview()
                }
            });
        })
        dimView?.alpha = 0.0;
        player?.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.player?.alpha = 0.0
            self.dimView?.alpha = 1.0
            self.dimView?.activityStartAnimating(activityColor: .white, backgroundColor: .clear)
            self.player?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
}

extension MovieDetailViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .transitionCrossDissolve) {
            self.player?.alpha = 1.0
            self.dimView?.activityStopAnimating()
        } completion: { isCompleted in
            self.player?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            playerView.playVideo()
        }
    }
}

extension MovieDetailViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
