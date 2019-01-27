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
import Alamofire
import VegaScrollFlowLayout

class HomeViewController: UICollectionViewController {
    private let reuseIdentifier = "QardView"
    private var qards: [Qard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set "New QaRd" button
        let plusButton = UIButton(type: .custom)
        plusButton.addTarget(self, action: #selector(launchNewQardForm), for: .touchUpInside)

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
        
        let layout = VegaScrollFlowLayout()
        layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 260)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 20

        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(QardView.self, forCellWithReuseIdentifier: self.reuseIdentifier)

    }
    
    @objc func launchCamera() {
        
    }
    
    @objc func launchNewQardForm() {
        let newQardFormViewController = NewQardFormViewController()
        self.navigationController?.pushViewController(newQardFormViewController, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.qards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let qard = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? QardView else {
            return UICollectionViewCell()
        }
        // Configure the qard
        
        return qard
    }
}
