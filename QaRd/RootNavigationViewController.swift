//
//  ViewController.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(HomeViewController(nibName: nil, bundle: nil), animated: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

