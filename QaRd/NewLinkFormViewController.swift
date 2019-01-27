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

protocol LinkFormDelegate: class {
    func onLinkComplete(link: Link)
}

class NewLinkFormViewController: FormViewController {
    weak var delegate: LinkFormDelegate?
    
    var link = Link();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.white
        // Set Check Mark
        let attributes = [NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .solid)]
        let checkMarkBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIcon(name: .check),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(saveLink))
        checkMarkBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        checkMarkBarButtonItem.setTitleTextAttributes(attributes, for: .selected)
        checkMarkBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = checkMarkBarButtonItem
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "BreeSerif-Regular", size: 28)
        titleLabel.text = "New Link"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        form +++ Section("Link Information")
            <<< TextRow(){ row in
                row.title = "URL"
                row.placeholder = "Enter link URL"
                row.value = link.URL ?? ""
                row.tag = "url"
                }.onChange {row in
                    self.link.URL = row.value ?? ""
            }
            <<< TextRow(){ row in
                row.title = "Username"
                row.placeholder = "Enter username"
                row.value = link.username ?? ""
                row.tag = "username"
                }.onChange {row in
                    self.link.username = row.value ?? ""
            }
            <<< TextRow(){ row in
                row.title = "Message"
                row.placeholder = "Enter an optional message"
                row.value = link.message ?? ""
                row.tag = "message"
                }.onChange {row in
                    self.link.message = row.value ?? ""
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent);
    }
    
    @objc func saveLink() {
        self.delegate?.onLinkComplete(link: self.link)
    }
}

