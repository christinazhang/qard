//
//  QardView.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit

class QardView: UIView {
    var qard: Qard
    
    init(qard: Qard) {
        self.qard = qard
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
