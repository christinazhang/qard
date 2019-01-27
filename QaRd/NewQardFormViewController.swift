//
//  NewQardFormViewController.swift
//  QaRd
//
//  Created by Kevin Wong on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import ColorPickerRow
typealias Emoji = String

protocol FormViewDelegate: class {
    func onFormComplete(qard: Qard, isNewCard: Bool)
    func onFormDelete(qard: Qard)
}

class NewQardFormViewController: FormViewController, LinkFormDelegate {
    var titleLabelText: String = "New QaRd" {
        didSet {
            self.titleLabel.text = self.titleLabelText
            self.titleLabel.sizeToFit()
        }
    }
    var isNewCard: Bool = true // AKA "Is editing... but reverse"
    var titleLabel: UILabel = UILabel()
    var qard: Qard = Qard()
    weak var delegate: FormViewDelegate?
    var linkSection = SelectableSection<ListCheckRow<String>>("Links", selectionType: .singleSelection(enableDeselection: true))
    var deleteLabel: UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Check Mark
        let attributes = [NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: Constants.fontAwesomeIconSize, style: .solid)]
        let checkMarkBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIcon(name: .check),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(saveQard))
        checkMarkBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        checkMarkBarButtonItem.setTitleTextAttributes(attributes, for: .selected)
        checkMarkBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = checkMarkBarButtonItem
        
        
        self.titleLabel.font = UIFont(name: "BreeSerif-Regular", size: 28)
        self.titleLabel.text = self.titleLabelText
        self.navigationItem.titleView = titleLabel
        self.navigationItem.title = " "
        
        self.edgesForExtendedLayout = []
        self.tableView.backgroundColor = .white
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.deleteLabel.text = "Delete QaRd"
        self.deleteLabel.textColor = .red
        self.deleteLabel.textAlignment = .center
        self.deleteLabel.sizeToFit()
        self.deleteLabel.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDelete))
        self.deleteLabel.addGestureRecognizer(tapGestureRecognizer)
        
        
        form +++ Section("Core Qard")
            <<< TextRow(){ row in
                row.title = "QaRd ID"
                row.placeholder = "e.g. Gaming, Business, Social"
                row.value = qard.id ?? ""
                row.tag = "qardId"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }.onChange { row in
                    self.qard.id = row.value ?? ""
                }
            
            <<< PushRow<Int>(){ row in
                row.title = "Color Scheme"
                row.options = [1, 2, 3, 4, 5]
                row.value = qard.gradient
                row.tag = "gradient"
                }.onPresent({ (from, to) in
                    to.selectableRowCellUpdate = { cell, row in
                        let gradient = Constants.gradients[row.selectableValue! - 1]
                        let gradientLayer = CAGradientLayer()
                        gradientLayer.colors = gradient
                        gradientLayer.frame = CGRect(x: 8, y: cell.bounds.midY - 12.5, width: 25, height: 25)
                        gradientLayer.cornerRadius = 2
                        gradientLayer.masksToBounds = true
                        cell.layer.addSublayer(gradientLayer)
                    }
                }).onChange({ row in
                    let index = (row.value ?? 1) - 1
                    self.qard.gradient = index
                })
            +++ Section("Header")
            <<< TextRow() { row in
                row.title = "Title"
                row.placeholder = "Leeroy Jenkins"
                row.value = qard.title ?? ""
                }.onChange {row in
                    self.qard.title = row.value ?? "";
            }
            <<< TextRow() { row in
                row.title = "Subtitle"
                row.placeholder = "At least I got some chicken"
                row.value = qard.subtitle ?? ""
                }.onChange {row in
                    self.qard.subtitle = row.value ?? "";
            }
            
            +++ self.linkSection
            <<< ButtonRow() { row in
                row.title = "Add a link..."
                }.onCellSelection{ cell, row in
                    let newLinkFormViewController = NewLinkFormViewController()
                    newLinkFormViewController.delegate = self
                    self.navigationController?.pushViewController(newLinkFormViewController, animated: true)
        }
        
        
        for link in self.qard.links {
            form.last! <<< ListCheckRow<Link>(link.URL) { listRow in
                listRow.title = link.URL
                listRow.selectableValue = link
                listRow.value = nil
                listRow.onCellSelection { cell, row in
                    let newLinkFormViewController = NewLinkFormViewController()
                    newLinkFormViewController.delegate = self
                    newLinkFormViewController.link = link
                    self.navigationController?.pushViewController(newLinkFormViewController, animated: true)
                }
            }
        }
        
        self.deleteLabel.isHidden = self.isNewCard
        self.view.addSubview(self.deleteLabel)
        
        NSLayoutConstraint.activate([
          self.deleteLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
          self.deleteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
          self.deleteLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          self.deleteLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
          
          self.tableView.topAnchor.constraint(equalTo:self.view.topAnchor),
          self.tableView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
          self.tableView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
          self.tableView.bottomAnchor.constraint(equalTo:self.deleteLabel.topAnchor),
        ])
    }
    
    func onLinkComplete(link: Link) {
        self.qard.links.append(link)
        let listRow = ListCheckRow<Link>(link.URL)
        listRow.title = link.URL
        listRow.selectableValue = link
        listRow.value = nil
        listRow.onCellSelection { cell, row in
            let newLinkFormViewController = NewLinkFormViewController()
            newLinkFormViewController.delegate = self
            newLinkFormViewController.link = link
            self.navigationController?.pushViewController(newLinkFormViewController, animated: true)
        }
        self.linkSection += [listRow]
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveQard() {
        let userId = QServerManager.shared().userId
        
        if self.isNewCard {
            QServerManager.shared().createCard(userId: userId, qard: self.qard).responseJSON{ response in
                self.delegate?.onFormComplete(qard: self.qard, isNewCard: self.isNewCard)
            }
        } else {
            QServerManager.shared().updateCard(userId: userId, qard: self.qard).responseJSON{ response in
                self.delegate?.onFormComplete(qard: self.qard, isNewCard: self.isNewCard)
            }
        }
    }
    
    @objc func handleDelete() {
        print("handle delete")
        
        if let id = self.qard.id {
            print(id)
            QServerManager.shared().deleteCard(userId: QServerManager.shared().userId, qardId: id).response { response in
                print("deleting!", response)
                self.delegate?.onFormDelete(qard: self.qard)
            }
        }
    }
}
