//
//  MovieDetailCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var productionCountriesLabel: UILabel!
    @IBOutlet weak var spokenLanguageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var weblink: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    
    var detail: MovieDetailModel! {
        didSet {
            weblink.makeLink(title: "Homepage: ", for: detail.homepage)
            weblink.setOnClickListener(userInfo: [:]) { [weak self] respo in
                guard let self = self, let url = URL(string: self.detail.homepage ?? "") else { return }
                CustomeBroweser(controller: UIWindow.key?.rootViewController).open(openURL: url)
            }
            originalTitleLabel.animatedTextWithTitle(title: "Original title: ", for: detail.originalTitle)
            languageLabel.animatedTextWithTitle(title: "Original Language: ", for: detail.language)
            taglineLabel.text = detail.tagline
            statusLabel.animatedTextWithTitle(title: "Status: ",for: detail.status)
            adultLabel.animatedTextWithTitle(title: "Adult: ",for: (detail.adult ?? false) ? "Yes": "NO")
            spokenLanguageLabel.animatedTextWithTitle(title: "Spoken Languages: ",for: (detail.spokenLanguages ?? []).map { $0.englishName ?? "" }.joined(separator: ", "))
            productionCountriesLabel.animatedTextWithTitle(title: "Production Countries: ",for: (detail.productionCountries ?? []).map { $0.name ?? "" }.joined(separator: ", "))
            genreLabel.animatedTextWithTitle(title: "Genre: ", for:(detail.genres ?? []).map { $0.name ?? "" }.joined(separator: ", "))
            
            
            let totalString = NSMutableAttributedString()
            let headerAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
            let subtitleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            
            let dict = Dictionary(grouping: (detail.credits?.crew ?? []), by: \.department)
            _ = dict.map { repos in
                let header = NSMutableAttributedString(attributedString: NSAttributedString(string: (repos.key ?? "") + ": ", attributes: headerAttribute))
                header.append(NSAttributedString(string: repos.value.map { $0.name ?? "" }.joined(separator: ", "), attributes: subtitleAttribute))
                totalString.append(header)
                if dict.map({ $0.key ?? "" }).last ?? "" != repos.key {
                    totalString.append(NSMutableAttributedString(string: "\n\n"))
                }
            }
            crewLabel.isUserInteractionEnabled = true            
            crewLabel.attributedText = totalString
            overviewLabel.animatedTextWithTitle(title: "Overview: ", for: detail.overview)
            budgetLabel.animatedTextWithTitle(title: "Budget: ", for: detail.budgetText)
            revenueLabel.animatedTextWithTitle(title: "Revenue: ", for: detail.revenuText)
        }
    }
}
