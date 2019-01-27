//
//  HomeViewController.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class HomeViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set "New QaRd" button
        let plusButton = UIButton(type: .custom)
        let plusIconImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .black, size: CGSize(width: Constants.fontAwesomeIconSize, height: Constants.fontAwesomeIconSize))
        let plusAttributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: "Avenir-Heavy", size: 16)!]
        let plusAttributedString = NSAttributedString(string: "New QaRd", attributes: plusAttributes)
        
        plusButton.setImage(plusIconImage, for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        plusButton.setAttributedTitle(plusAttributedString, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        
        // Set Camera Button
        let cameraAttributes = [NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .solid)]
        let cameraBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIcon(name: .camera),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(launchCamera))
        cameraBarButtonItem.setTitleTextAttributes(cameraAttributes, for: .normal)
        cameraBarButtonItem.setTitleTextAttributes(cameraAttributes, for: .selected)
        cameraBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = cameraBarButtonItem
    }
    
    @objc func launchCamera() {
        
    }
}
