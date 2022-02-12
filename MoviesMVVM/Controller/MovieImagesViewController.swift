//
//  MovieImagesViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/7/22.
//

import UIKit
import Combine

class MovieImagesViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    private lazy var bindings = Set<AnyCancellable>()
    var viewModel: MovieImageViewModel!
    var id: String?
    var type:pictureType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pictures"
        viewModel = MovieImageViewModel(id: id, type: type ?? .Movie)
        imageCollectionView.registerNib(nib: MovieImageListCell.reuseIdentifier)
        imageCollectionView.collectionViewLayout = getCompositionalLayout()
        
        let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.imageCollectionView.restore()
                self.view.activityStartAnimating(activityColor: .white, backgroundColor: .black)
                break
            case .finishedLoading:
                if (self.viewModel.imageList.count > 0) {
                    self.view.activityStopAnimating()
                    self.imageCollectionView.delegate = self
                    self.imageCollectionView.dataSource = self
                    self.imageCollectionView.reloadData()
                }else{
                    self.view.activityStopAnimating()
                    self.imageCollectionView.setEmptyMessage("No data Found")
                }
                break
            case .error(let error):
                self.view.activityStopAnimating()
                TTGSnackbar(message: error.localizedDescription, duration: .middle).show()
                break
            case .none:
                break
            }
        }
        viewModel.$state.sink(receiveCompletion: { completion in
        }, receiveValue: stateValueHandler).store(in: &bindings)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationSetup()
    }
}

extension MovieImagesViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MovieImageListCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.data = viewModel.imageList[safe:indexPath.row]
        return cell
    }
}
extension MovieImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieImageListCell, let image = cell.imageView.image {
            let imageInfo      = GSImageInfo(image: image, imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: cell)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            self.present(imageViewer, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.showAnimation()
    }
    
}






