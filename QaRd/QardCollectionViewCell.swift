//
//  QardCollectionViewCell.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class QardCollectionViewCell: UICollectionViewCell {
    var qard: Qard? {
        didSet {
            self.titleLabel.text = self.qard?.title
            self.subtitleLabel.text = self.qard?.subtitle
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = self.qard?.gradient
            self.layer.insertSublayer(gradientLayer, at: 0)
            self.backgroundColor = self.qard?.color
            
            Alamofire.request("https://api.qrserver.com/v1/create-qr-code/?size=175x175&data=wiji").response { response in
                print("Response: \(String(describing: response.response))")
    
                if let data = response.data {
                    let qrImage = UIImage(data: data,scale:1.0)
                    self.qrImageViewBackground.backgroundColor = .white
                    self.qrImageView.image = qrImage
                }
            }
        }
    }
    
    var titleLabel: UILabel = UILabel()
    var subtitleLabel: UILabel = UILabel()
    var qrImageView: UIImageView = UIImageView()
    // It's a hackathon i'm gonna make this a uiview
    var qrImageViewBackground: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.initLabels()
        self.initQRImageView()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLabels() {
        self.titleLabel.font = UIFont(name: "BreeSerif-Regular", size: 28)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false


        self.subtitleLabel.font = UIFont(name: "Avenir-Book", size: 16)
        self.subtitleLabel.textColor = .white
        self.subtitleLabel.textAlignment = .center
        self.addSubview(self.subtitleLabel)
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initQRImageView() {
        self.qrImageViewBackground.layer.cornerRadius = 3
        self.qrImageViewBackground.layer.masksToBounds = true
        self.qrImageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        self.qrImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.qrImageViewBackground)
        self.addSubview(self.qrImageView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            self.qrImageViewBackground.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 32),
            self.qrImageViewBackground.widthAnchor.constraint(equalToConstant: 175),
            self.qrImageViewBackground.heightAnchor.constraint(equalToConstant: 175),
            self.qrImageViewBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.qrImageView.topAnchor.constraint(equalTo: self.qrImageViewBackground.topAnchor, constant: 20),
            self.qrImageView.widthAnchor.constraint(equalToConstant: 135),
            self.qrImageView.heightAnchor.constraint(equalToConstant: 135),
            self.qrImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
}
