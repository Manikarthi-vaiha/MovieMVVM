//
//  SectionHeaderReusableView.swift
//  MoviesMVVM
//
//  Created by Mani on 2/8/22.
//

import UIKit


class SectionHeaderReusableView: UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
    
    lazy var ContainerView:UIView =  {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.lightGray
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupLayout()
    }
    
    override func layoutSubviews() {
        ContainerView.layer.cornerRadius = 5
        ContainerView.layer.masksToBounds = true
    }
    
    
    func setupLayout() {
        self.addSubview(ContainerView)
        ContainerView.translatesAutoresizingMaskIntoConstraints = false
        ContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        ContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        ContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        ContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        ContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
        ContainerView.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: ContainerView.topAnchor, constant: 5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor, constant: -5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: ContainerView.leftAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: ContainerView.rightAnchor, constant: -5).isActive = true
        
    }
    
}

