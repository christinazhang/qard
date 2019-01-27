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
        
        qard.links = [Link(url: "test", username: "fsafda", message: "dsfsd"), Link(url: "test2", username: "fsaf3333da", message: "444dsfsd")]
        
        form +++ Section("Core Qard")
            <<< TextRow(){ row in
                row.title = "QaRd ID"
                row.placeholder = "e.g. Gaming, Business, Social"
                row.value = qard.id ?? ""
                row.tag = "qardId"
                }.onChange { row in
                    self.qard.id = row.value ?? ""
                }
            <<< PushRow<Int>(){ row in
                row.title = "Gradient"
                row.options = [1, 2, 3, 4, 5]
                row.value = (Constants.gradients.enumerated().first(where: { (index, gradient) -> Bool in
                    gradient.first == qard.gradient.first
                })?.offset ?? 0) + 1
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
//                        cell.addSubview(swatches[row.selectableValue!])
                    }
                }).onChange({ row in
                    let index = (row.value ?? 1) - 1
                    self.qard.gradient = Constants.gradients[index]
                })
            <<< SwitchRow() { row in      // initializer
                row.title = "Private"
                row.tag = "private"
                row.value = qard.isPrivate ?? true
                }.onChange { row in
                    self.qard.isPrivate = row.value ?? true;
            }
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
        self.delegate?.onFormComplete(qard: self.qard, isNewCard: self.isNewCard)
    }
}
