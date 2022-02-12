//
//  MovieCastKnownAsCell.swift
//  MoviesMVVM
//
//  Created by Mani on 2/3/22.
//

import UIKit

class MovieCastKnownAsCell: UITableViewCell {
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roundedIcon: UIView!
    
    lazy var dateF: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-mm-dd"
        return df
    }()
    
    var data:PassionCast? {
        didSet{
            if let date = dateF.date(from: data?.releaseDate ?? data?.first_air_date ?? "") {
                let df = DateFormatter()
                df.dateFormat = "yyyy"
                dateLabel.text = df.string(from: date)
                dateLabel.textAlignment = .left
            }else{
                dateLabel.textAlignment = .center
                dateLabel.text = "-"
            }
            
            var job = ""
            if let jobDesc = data?.job, !jobDesc.isEmpty {
                job = " (\(jobDesc))"
            }else if let jobDesc = data?.character, !jobDesc.isEmpty {
                job = " (\(jobDesc))"
            }
            if let title = data?.originalTitle {
                let nameAttri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
                let asAttri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
                let rolAttri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]
                let header = NSMutableAttributedString(attributedString: NSAttributedString(string: title, attributes: nameAttri))
                header.append(NSAttributedString(string: job.isEmpty ? "" : " as", attributes: asAttri))
                header.append(NSAttributedString(string: job, attributes: rolAttri))
                overviewLabel.attributedText = header
            }else if let name = data?.name {
                let nameAttri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
                let asAttri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
                let rolAttri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]
                let header = NSMutableAttributedString(attributedString: NSAttributedString(string: name, attributes: nameAttri))
                header.append(NSAttributedString(string: job.isEmpty ? "" : " as", attributes: asAttri))
                header.append(NSAttributedString(string: job, attributes: rolAttri))
                overviewLabel.attributedText = header
            }
            roundedIcon.layer.borderColor = UIColor.white.cgColor
            roundedIcon.layer.borderWidth = 0.8
            roundedIcon.layer.cornerRadius = 7
            roundedIcon.layer.masksToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
