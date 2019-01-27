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

class HomeViewController: UICollectionViewController, FormViewDelegate {

    private let reuseIdentifier = "QardCollectionViewCell"
    private var qards: [Qard] = [Qard(id: "card ID", gradient: [UIColor.purple.cgColor, UIColor.blue.cgColor], color: nil, isPrivate: false, title: "card title", subtitle: "this is a subtitle", links: []),]
    
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
        layout.itemSize = CGSize(width: self.collectionView.frame.width - 64, height: 320)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 20

        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(QardCollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)

    }
    
    @objc func launchCamera() {
        
    }
    
    @objc func launchNewQardForm() {
        let newQardFormViewController = NewQardFormViewController()
        newQardFormViewController.delegate = self
        self.navigationController?.pushViewController(newQardFormViewController, animated: true)
    }
    
    // MARK: - FormViewDelegate
    
    func onFormComplete(qard: Qard) {
        self.qards.append(qard);
        self.collectionView.reloadData()
        self.navigationController?.popViewController(animated: true)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? QardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.qard = self.qards[indexPath.row]
        cell.layer.masksToBounds = false;
        cell.layer.shadowOffset = CGSize(width: 0, height: 2);
        cell.layer.shadowRadius = 5;
        cell.layer.shadowOpacity = 0.5;
        
        return cell
    }
}
