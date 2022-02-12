//
//  MovieCastViewController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import UIKit
import Combine

class MovieCastViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var knownAsLabel: UILabel!
    @IBOutlet weak var intrestedLabel: UILabel!
    @IBOutlet weak var bdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthPlace: UILabel!
    @IBOutlet weak var papularity: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var deathDay: UILabel!
    @IBOutlet weak var faceBookView: UIView!
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var instaView: UIView!
    @IBOutlet weak var profileBackgroundImage: UIImageView!    
    private var statusbarView: UIView?
    private var bindings = Set<AnyCancellable>()
    var personID: String?
    private var viewModel: MovieCastViewModel!
    private let backButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Info"
        navigationController?.navigationSetup()
        setupAPIResponse()
        setupStatusBar()
        [faceBookView,twitterView,instaView].forEach { $0?.isHidden = true }
        setupImageView()
    }
    
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        let controller = self.getController(controller: PersonMediaTypeController()) as? PersonMediaTypeController
        if let url = URL(string: posterPath+(viewModel.MovieCastDetailResponse?.profilePath ?? "")) {
            controller?.url = url
        }
        controller?.castName = viewModel.MovieCastDetailResponse?.name
        controller?.movieCastResponse = viewModel.MovieCastKnownAsModel
        navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
    }
    
    func setupStatusBar(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        statusbarView = UIView(frame: UIWindow.key?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect())
        self.statusbarView?.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor =  .clear
        view.addSubview(statusbarView ?? UIView())
    }
    
    func setupAPIResponse(){
        viewModel = MovieCastViewModel(model: HTTPClient(), personID: personID)
        viewModel.getAPiResponse()
        viewModel.$socialMediaData.sink { comple in
            
        } receiveValue: { [weak self] repo in
            guard let self = self else {  return }
            if let fbid = repo?.facebook_id, let url = URL(string: facebookURL+fbid) {
                UIView.transition(with: self.faceBookView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.faceBookView.isHidden = false
                }, completion: nil)
                self.faceBookView.setOnClickListener(userInfo: [:]) { _ in
                    UIApplication.shared.open(url)
                }
            }
            if let twitterID = repo?.twitter_id, let url = URL(string: twitterURL+twitterID)  {
                UIView.transition(with: self.twitterView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.twitterView.isHidden = false
                }, completion: nil)
                self.twitterView.setOnClickListener(userInfo: [:]) { _ in
                    UIApplication.shared.open(url)
                }
            }
            if let instaID = repo?.instagram_id, let url = URL(string: instagramURL+instaID)   {
                UIView.transition(with: self.instaView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.instaView.isHidden = false
                }, completion: nil)
                self.instaView.setOnClickListener(userInfo: [:]) { _ in
                    UIApplication.shared.open(url)
                }
            }
        }.store(in: &bindings)
        
        let response: (MovieCastModel?) -> Void = { [weak self] completion in
            guard let self = self else {  return }
            
            if let deathDay = completion?.deathday, let bday = completion?.birthday  {
                let d = deathDay.getDate(formate: "yyyy-mm-dd", to: "yyyy") ?? ""
                let b = bday.getDate(formate: "yyyy-mm-dd", to: "yyyy") ?? ""
                self.deathDay.animatedText(for: "(\(b)-\(d))"    )
            }
            self.papularity.animatedTextWithTitle(title: "Popularity: ", for: "\(completion?.popularity ?? 0.0)")
            self.overviewLabel.animatedTextWithTitle(title: "Biography: ", for: completion?.biography)
            if let geneder = completion?.gender {
                switch geneder {
                case 0:
                    self.genderLabel.animatedTextWithTitle(title: "Gender: ", for: "Transgender")
                case 1:
                    self.genderLabel.animatedTextWithTitle(title: "Gender: ", for: "Female")
                case 2:
                    self.genderLabel.animatedTextWithTitle(title: "Gender: ", for: "Male")
                default:
                    break
                }
            }
            self.birthPlace.animatedTextWithTitle(title: "Place of Birth: ", for: completion?.placeOfBirth)
            self.bdayLabel.animatedTextWithTitle(title: "Birthday: ", for: completion?.birthday ?? "")
            self.intrestedLabel.animatedTextWithTitle(title: "Known For: ", for: completion?.knownForDepartment)
            
            self.nameLabel.text = completion?.name
            
            self.knownAsLabel.animatedTextWithTitle(title: "Also Known As ", for: (completion?.alsoKnownAs ?? []).map ({ $0 }).joined(separator: " | "))
            if let url = URL(string: posterPath+(completion?.profilePath ?? "")) {
                ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink { completion in
                } receiveValue: { image in
                    UIView.transition(with: self.profileImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.profileBackgroundImage.image = image
                        self.profileImageView.image = image
                        self.profileImageView.isUserInteractionEnabled = true
                        self.profileImageView.setOnClickListener(userInfo: [:]) { _ in
                            let imageInfo      = GSImageInfo(image: image, imageMode: .aspectFit)
                            let transitionInfo = GSTransitionInfo(fromView: self.profileImageView)
                            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                            self.present(imageViewer, animated: true, completion: nil)
                        }
                    }, completion: nil)
                }.store(in: &self.bindings)
            }
        }
        
        viewModel.$state.sink { completion in
            switch completion {
            case .loading:
                break
            case .finishedLoading:
                break
            case .error(let error):
                TTGSnackbar(message: error.localizedDescription, duration: .middle).show()
                break
            case .none:
                break
            }
        }.store(in: &bindings)
        
        viewModel.$MovieCastDetailResponse.receive(on: RunLoop.main).sink(receiveCompletion: { completion in
        }, receiveValue: response).store(in: &bindings)
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.tintColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setupImageView(){
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
            controller?.id = self.viewModel.personID
            controller?.type = .Person
            self.navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
        }), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
}

extension MovieCastViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
