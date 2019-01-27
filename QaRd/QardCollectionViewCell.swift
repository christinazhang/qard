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
import FontAwesome_swift

class QardCollectionViewCell: UICollectionViewCell {
    // Isaiah this is so bad omg
    var qServerManager: QServerManager = QServerManager.shared()
    
    var qard: Qard? {
        didSet {
            self.titleLabel.text = self.qard?.title
            self.subtitleLabel.text = self.qard?.subtitle
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = Constants.gradients[self.qard?.gradient ?? 0]
            self.layer.insertSublayer(gradientLayer, at: 0)
//            self.backgroundColor = self.qard?.color
            
            if let qard = qard {
                qServerManager.generateQRCode(userId: "wiji", qard: qard).response { response in
                    print("Response: \(String(describing: response.response))")
                    if let data = response.data {
                        let qrImage = UIImage(data: data,scale:1.0)
                        self.qrImageViewBackground.backgroundColor = .white
                        self.qrImageView.image = qrImage
                    }
                }
            }


        }
    }
    var editIconLabel: UILabel = UILabel()
    var titleLabel: UILabel = UILabel()
    var subtitleLabel: UILabel = UILabel()
    var qrImageView: UIImageView = UIImageView()
    // It's a hackathon i'm gonna make this a uiview
    var qrImageViewBackground: UIView = UIView()
    
    weak var delegate: HomeViewController?
    
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
        
        self.editIconLabel.font = UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .solid)
        self.editIconLabel.textColor = .white
        self.editIconLabel.text = String.fontAwesomeIcon(name: .edit)
        self.editIconLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.editIconLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapEdit(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.editIconLabel.addGestureRecognizer(tapGestureRecognizer)
        self.editIconLabel.isUserInteractionEnabled = true
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
            
            self.editIconLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.editIconLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }
    
    @objc func handleTapEdit(_ sender: UITapGestureRecognizer) {
        if let qard = self.qard {
            self.delegate?.qardDidPressEdit(qard)
        }
    }
}
