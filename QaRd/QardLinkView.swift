//
//  QardLinkView.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-27.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class QardLinkView: UIView {
    var messageLabel: UILabel = UILabel()
    var iconLabel: UILabel = UILabel()
    
    // oof a backgroundview so i can mask and still show an icon
    var backgroundView: UIView = UIView()
    var link: Link
    var icon: FontAwesome = .plus { // ONLY CHANGE THIS TO BRANDS OR I WILL BE SAD
        didSet {
            self.iconLabel.font = UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .brands)
            self.iconLabel.text = String.fontAwesomeIcon(name: self.icon)
        }
    }
    
    init(link: Link) {
        self.link = link
        super.init(frame: .zero)
        
        // got too lazy to do init functions (christina, 2:35 AM)
        self.backgroundView.backgroundColor = .white
        self.backgroundView.layer.cornerRadius = 5
        self.backgroundView.layer.masksToBounds = true
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backgroundView)
        
        self.messageLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.text = link.message
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.messageLabel)
        
        self.iconLabel.font = UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .solid)
        self.iconLabel.text = String.fontAwesomeIcon(name: self.icon)
        self.iconLabel.textColor = .white
        self.iconLabel.sizeToFit()
        self.iconLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.iconLabel)
        
        NSLayoutConstraint.activate([
            self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35 + 17.5 + 16),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.iconLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.iconLabel.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maskLayer = CAShapeLayer()
        let maskPath = UIBezierPath(rect: self.bounds)
        maskPath.addArc(withCenter: CGPoint(x: 35, y: 35), radius: 17.5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        maskLayer.path = maskPath.cgPath
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.backgroundView.layer.mask = maskLayer
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        if let urlString = self.link.URL, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
