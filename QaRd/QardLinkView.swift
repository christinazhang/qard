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
    var link: Link
    
    init(link: Link) {
        self.link = link
        super.init(frame: .zero)
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.messageLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.text = link.message
        self.messageLabel.sizeToFit()
        self.addSubview(self.messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
