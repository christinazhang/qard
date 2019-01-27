//
//  NewLinkFormViewController.swift
//  QaRd
//
//  Created by Kevin Wong on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import Eureka

protocol LinkFormDelegate: class {
    func onLinkComplete(link: Link)
}

class NewLinkFormViewController: FormViewController {
    weak var delegate: LinkFormDelegate?
    
    var link = Link()
    var stackView = UIStackView()
    var urlRow: TextRow?
    var usernameRow: TextRow?

    
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
        
        let urlRow = TextRow(){ row in
            row.title = "URL"
            row.placeholder = "Enter link URL"
            row.value = link.URL ?? ""
            row.tag = "url"
            }.onChange {row in
                self.link.URL = row.value ?? ""
        }
        
        let usernameRow = TextRow(){ row in
            row.title = "Username"
            row.placeholder = "Enter username"
            row.value = link.username ?? ""
            row.tag = "username"
            }.onChange {row in
                self.link.username = row.value ?? ""
        }
        
        self.urlRow = urlRow
        self.usernameRow = usernameRow
        form +++ Section("Link Information")
            <<< urlRow
            <<< usernameRow
            <<< TextRow(){ row in
                row.title = "Message"
                row.placeholder = "Enter an optional message"
                row.value = link.message ?? ""
                row.tag = "message"
                }.onChange {row in
                    self.link.message = row.value ?? ""
        }
        
        self.stackView.axis = .horizontal
        self.stackView.spacing = 16
        self.stackView.alignment = .center
        
        let label = UILabel()
        label.text = "QUICK ADD"
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.sizeToFit()
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let iconInfos: [Constants.IconInfo] = [
        (.brands, .github),
        (.brands, .linkedinIn),
        (.brands, .facebookF),
        (.brands, .twitter),
        (.brands, .steamSymbol)
        ]
        
        // oh god i ams o lazy
        let iconColorMap: [FontAwesome : UIColor] = [
            .github : .black,
            .linkedinIn : UIColor(hex: 0x0e76a8),
            .facebookF : UIColor(hex: 0x3b5998),
            .twitter : UIColor(hex: 0x1da1f2),
            .steamSymbol : .black
        ]
        
        
        iconInfos.forEach { (iconInfo) in
            let quickAddView = QuickAddView(icon: iconInfo)
            quickAddView.translatesAutoresizingMaskIntoConstraints = false
            quickAddView.backgroundColor = iconColorMap[iconInfo.icon]
            quickAddView.delegate = self
            NSLayoutConstraint.activate([
                quickAddView.widthAnchor.constraint(equalToConstant: 48),
                quickAddView.heightAnchor.constraint(equalToConstant: 48),
            ])
            // quickAddView.delegate = self
            self.stackView.addArrangedSubview(quickAddView)
        }
        self.view.addSubview(self.stackView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            self.stackView.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 1, constant: 0),
            self.stackView.heightAnchor.constraint(equalToConstant: 48),
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent);
    }
    
    @objc func saveLink() {
        self.delegate?.onLinkComplete(link: self.link)
    }
    
    func fillInQuickAdd(icon: FontAwesome) {
        self.urlRow?.value = Constants.linkMap[icon]
        let alert = UIAlertController(title: "Quick Add", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let username = textField.text ?? ""
            self.urlRow?.value?.append(username)
            self.usernameRow?.value = username
            self.tableView.reloadData()
        }
        
        // the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        self.present(alert, animated: true, completion: nil)

        self.tableView.reloadData()
    }
}

