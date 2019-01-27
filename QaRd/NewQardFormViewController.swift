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
    func onFormComplete(qard: Qard) 
}

class NewQardFormViewController: FormViewController, LinkFormDelegate {
    
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
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "BreeSerif-Regular", size: 28)
        titleLabel.text = "New QaRd"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        self.navigationItem.title = " "
        
        self.edgesForExtendedLayout = []
        self.tableView.backgroundColor = .white
        
        qard.links = [Link(url: "test", username: "fsafda", message: "dsfsd"), Link(url: "test2", username: "fsaf3333da", message: "444dsfsd")]
        
        form +++ Section("Core Qard")
            <<< TextRow(){ row in
                row.title = "QaRd ID"
                row.placeholder = "e.g. Gaming, Business, Social"
                row.tag = "qardId"
                }.onChange { row in
                    self.qard.id = row.value ?? "";
                }
            //  Custom color palette example
            <<< ColorPickerRow("colors2") { (row) in
                row.title = "Background Color"
                row.isCircular = true
                row.showsCurrentSwatch = true
                row.showsPaletteNames = false
                row.value = UIColor.white
                }
                .cellSetup { (cell, row) in
                    let palette = ColorPalette(name: "All",
                                               palette: [ColorSpec(hex: "#ffffff", name: ""),
                                                         ColorSpec(hex: "#e2e2e2", name: ""),
                                                         ColorSpec(hex: "#c6c6c6", name: ""),
                                                         ColorSpec(hex: "#aaaaaa", name: ""),
                                                         ColorSpec(hex: "#8e8e8e", name: ""),
                                                         ColorSpec(hex: "#707070", name: ""),
                                                         ColorSpec(hex: "#545454", name: ""),
                                                         ColorSpec(hex: "#383838", name: ""),
                                                         ColorSpec(hex: "#1c1c1c", name: "")])
                    cell.palettes = [palette]
            }
            <<< PushRow<[CGColor]>(){
                $0.title = "Color"
                $0.options = Constants.gradients
                $0.value = Constants.gradients[0]
                $0.tag = "color"
                }.onChange {row in
                    self.qard.gradient = row.value ?? Constants.gradients[0];
            }
            <<< SwitchRow() { row in      // initializer
                row.title = "Private"
                row.tag = "private"
                }.onChange { row in
                    self.qard.isPrivate = row.value ?? true;
            }
            +++ Section("Header")
            <<< TextRow() { row in
                row.title = "Title"
                row.placeholder = "Leeroy Jenkins"
                }.onChange {row in
                    self.qard.title = row.value ?? "";
            }
            <<< TextRow() { row in
                row.title = "Subtitle"
                row.placeholder = "At least I got some chicken"
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
        self.delegate?.onFormComplete(qard: self.qard)
    }
}
