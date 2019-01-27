//
//  NewLinkFormViewController.swift
//  QaRd
//
//  Created by Kevin Wong on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class NewLinkFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        form +++ Section("Link Information")
            <<< TextRow(){ row in
                row.title = "URL"
                row.placeholder = "Enter link URL"
                row.tag = "url"
            }
            <<< TextRow(){ row in
                row.title = "Username"
                row.placeholder = "Enter username"
                row.tag = "username"
            }
            <<< TextRow(){ row in
                row.title = "Message"
                row.placeholder = "Enter an optional message"
                row.tag = "message"
            }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent);
        
    }
    
    
}

