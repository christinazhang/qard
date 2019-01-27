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
typealias Emoji = String

protocol FormViewDelegate: class {
    func onFormComplete(qard: Qard) 
}

class NewQardFormViewController: FormViewController, LinkFormDelegate {
    
    var qard: Qard = Qard();
    weak var delegate: FormViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveQard))
        
        qard.links = [Link(url: "test", username: "fsafda", message: "dsfsd"), Link(url: "test2", username: "fsaf3333da", message: "444dsfsd")]
        
        form +++ Section("Core Qard")
            <<< TextRow(){ row in
                row.title = "Qard Id"
                row.placeholder = "Enter text here"
                row.tag = "qardId"
                }.onChange { row in
                    self.qard.id = row.value ?? "";
            }
            <<< PushRow<UIColor>(){
                $0.title = "Color"
                $0.options = [UIColor.blue, UIColor.red, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.white]
                $0.value = .blue
                $0.tag = "color"
                }.onChange {row in
                    self.qard.color = row.value ?? .blue;
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
                row.placeholder = "Title of Qard"
                }.onChange {row in
                    self.qard.title = row.value ?? "";
            }
            <<< TextRow() { row in
                row.title = "Subtitle"
                row.placeholder = "Subtitle of Qard"
                }.onChange {row in
                    self.qard.subtitle = row.value ?? "";
            }
            
            +++ SelectableSection<ListCheckRow<String>>("Links", selectionType: .singleSelection(enableDeselection: true))
        
            <<< ButtonRow() { row in
                row.title = "Add Link"
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
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveQard() {
        self.delegate?.onFormComplete(qard: self.qard)
    }
}
