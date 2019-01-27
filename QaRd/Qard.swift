//
//  Qard.swift
//  QaRd
//
//  Created by Kevin Wong on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit

class Link {
    var URL: String?
    var username: String?
    var message: String?
}

class Qard {
    var id: String?
    var color: UIColor?
    var isPrivate: Bool?
    
    var title: String?
    var subtitle: String?
    
    var links: [String: String]?
}
