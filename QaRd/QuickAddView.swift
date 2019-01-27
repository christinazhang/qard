//
//  QuickAddView.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-27.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import Eureka

class QuickAddView: UIView {
    var iconLabel: UILabel = UILabel()
    weak var delegate: NewLinkFormViewController?
    var icon: FontAwesome
    
    init(icon: Constants.IconInfo) {
        self.icon = icon.icon
        super.init(frame: .zero)
//        self.backgroundColor = .purple
        self.iconLabel.font = UIFont.fontAwesome(ofSize: 28, style: icon.style)
        self.iconLabel.text = String.fontAwesomeIcon(name: icon.icon)
        self.iconLabel.textColor = .white
        self.iconLabel.translatesAutoresizingMaskIntoConstraints = false
        self.iconLabel.sizeToFit()
        self.addSubview(self.iconLabel)
        
        NSLayoutConstraint.activate([
            self.iconLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.iconLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.fillInQuickAdd(icon: self.icon)
    }
}
