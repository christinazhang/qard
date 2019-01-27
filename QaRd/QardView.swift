//
//  QardView.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit

class QardView: UICollectionViewCell {
    var qard: Qard
    
    var titleLabel: UILabel = UILabel()
    var subtitleLabel: UILabel = UILabel()
    
    init(qard: Qard) {
        self.qard = qard
        super.init(frame: .zero)
        self.layer.cornerRadius = 5
        self.initLabels()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLabels() {
        self.titleLabel.text = self.qard.title
        self.titleLabel.font = UIFont(name: "BreeSerif-Regular", size: 28)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false


        self.subtitleLabel.text = self.qard.subtitle
        self.subtitleLabel.font = UIFont(name: "Avenir-Book", size: 16)
        self.subtitleLabel.textColor = .white
        self.subtitleLabel.textAlignment = .center
        self.addSubview(self.subtitleLabel)
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // yo idk what this is
//        Alamofire.request("https://api.qrserver.com/v1/create-qr-code/?size=175x175&data=wiji").response { response in
//            print("Response: \(String(describing: response.response))")
//
//            if let data = response.data {
//
//                let qrImage = UIImage(data:data,scale:1.0)
//
//                let qrView = UIImageView(image: qrImage)
//                self.view.addSubview(qrView)
//                print("Data: \(data)")
//            }
//        }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
        ])
    }
    
}
