//
//  FullScreenQardViewController.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-27.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class FullScreenQardViewController: UIViewController {
    var contentView: UIView = UIView()
    var stackView: UIStackView = UIStackView()
    var titleLabel: UILabel = UILabel()
    var subtitleLabel: UILabel = UILabel()
    
    private func initLabels() {
        self.titleLabel.font = UIFont(name: "BreeSerif-Regular", size: 40)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        self.titleLabel.sizeToFit()
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.subtitleLabel.font = UIFont(name: "Avenir-Book", size: 20)
        self.subtitleLabel.textColor = .white
        self.subtitleLabel.textAlignment = .center
        self.subtitleLabel.sizeToFit()
        self.contentView.addSubview(self.subtitleLabel)
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initStackView() {
        self.stackView.spacing = 16
        self.stackView.axis = .vertical
        self.stackView.alignment = .center
        self.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.stackView)
    }
    
    private func initContentView() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contentView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 24),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.stackView.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 32),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func setQard(_ qard: Qard) {
        self.titleLabel.text = qard.title
        self.subtitleLabel.text = qard.subtitle
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = qard.gradient
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
        self.contentView.backgroundColor = qard.color
        
        qard.links.forEach { link in
            let linkView = QardLinkView(link: link)
            linkView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(linkView)
            
            NSLayoutConstraint.activate([
                linkView.heightAnchor.constraint(equalToConstant: 70),
                linkView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
                linkView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            ])
        }
    }
    
    override func viewDidLoad() {
        let attributes = [NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .solid)]
        let backBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIcon(name: .arrowLeft),
                                                  style: .plain,
                                                  target: self,
                                                  action: nil)
        backBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        backBarButtonItem.setTitleTextAttributes(attributes, for: .selected)
        backBarButtonItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        
        self.initContentView()
        self.initStackView()
        self.initLabels()
        self.setConstraints()
    }
}
