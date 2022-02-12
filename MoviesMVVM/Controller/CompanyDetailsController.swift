//
//  CompanyDetailsController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit
import Combine

class CompanyDetailsController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headqueaterLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var webAddress: UILabel!
    private lazy var bindings = Set<AnyCancellable>()
    var viewModel: CompanyViewModel!
    var companyID: String?
    var companyName: String?
    
    var detail: CompanyDetailModel? {
        didSet {
            if let detail = detail {
                if let languageCode = detail.origin_country {
                    countryLabel.text = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: languageCode)
                }
                if let head = detail.headquarters {
                    headqueaterLabel.text = head
                }
                if let desc = detail.description {
                    descriptionLabel.text = desc
                }
                if let name = detail.name {
                    nameLabel.text = name
                }
                if let web = detail.homepage, let url = URL(string: web) {
                    let attributedString = NSMutableAttributedString(string: web)
                    attributedString.addAttribute(.link, value: web, range: NSRange(location: 0, length: web.count))
                    webAddress.textColor = .white
                    webAddress.attributedText = attributedString
                    webAddress.isUserInteractionEnabled = true
                    webAddress.setOnClickListener(userInfo: [:]) { _ in
                        CustomeBroweser(controller: self).open(openURL: url)
                    }
                }
                
                if let url = detail.logoPathURL{
                    print(url.absoluteURL)
                    ImageLoader(urlSession: .shared, cache: ImageCache.shared.cache).publisher(for: url).sink { completion in
                        if case let .failure(error) = completion {
                            TTGSnackbar(message: error.localizedDescription, duration: .middle).show()
                            self.logo.backgroundColor = .clear
                        }
                    } receiveValue: { image in
                        UIView.transition(with: self.logo, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.logo.backgroundColor = .white
                            self.logo.image = image
                            self.logo.setOnClickListener(userInfo: [:]) { _ in
                                let imageInfo      = GSImageInfo(image: image, imageMode: .aspectFit)
                                let transitionInfo = GSTransitionInfo(fromView: self.logo)
                                let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                                self.present(imageViewer, animated: true, completion: nil)
                            }
                        }, completion: nil)
                    }.store(in: &self.bindings)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = companyName ?? ""
        logo.backgroundColor = .clear
        viewModel = CompanyViewModel(id: companyID ?? "")
        viewModel.$companyDetails.sink { completion in
            if case let .failure(error) = completion {
                TTGSnackbar(message: error.localizedDescription, duration: .middle).show()
            }
        } receiveValue: { model in
            self.detail = model
        }.store(in: &bindings)

    }        
}
