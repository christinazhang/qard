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
import AVFoundation
import QRCodeReader

class HomeViewController: UICollectionViewController, FormViewDelegate, QRCodeReaderViewControllerDelegate {

    private let reuseIdentifier = "QardCollectionViewCell"

    private var qards: [Qard] = [Qard(id: "card ID", gradient: Constants.gradients[2], isPrivate: false, title: "card title", subtitle: "this is a subtitle", links: []),]
    
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
                                                  action: #selector(scanAction))
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
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @objc func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let value = result?.value {
                let stuff = value.components(separatedBy: ",")
                let userId = stuff[0].replacingOccurrences(of: "[", with: "", options: NSString.CompareOptions.literal)
                let qardId = stuff[1].replacingOccurrences(of: "]", with: "", options: NSString.CompareOptions.literal)
                print(qardId)
                
                QServerManager.shared().getUserCard(userId: userId, qardId: qardId).response { response in
                    print("Response: \(String(describing: response.response))")
                    if let data = response.data {
                        do {
                            let stringDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                            
                            
                            let cardId: String = (stringDic?["cardId"] as! String)
                            
                            
                            let newQard: Qard = Qard(id: cardId, gradient: <#T##[CGColor]#>, isPrivate: <#T##Bool?#>, title: <#T##String?#>, subtitle: <#T##String?#>, links: <#T##[Link]#>)
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    
    @objc func launchNewQardForm() {
        let newQardFormViewController = NewQardFormViewController()
        newQardFormViewController.delegate = self
        
        // Set "bat bucket"
        let image = UIImage.fontAwesomeIcon(name: .arrowLeft, style: .solid, textColor: .black, size: CGSize(width: Constants.fontAwesomeIconSize, height: Constants.fontAwesomeIconSize))
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationItem.title = " "

        self.navigationController?.pushViewController(newQardFormViewController, animated: true)
    }
    
    // MARK: - FormViewDelegate
    
    func onFormComplete(qard: Qard) {
        self.qards.append(qard);
        self.collectionView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - QRCodeReaderViewControllerDelegate
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
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
