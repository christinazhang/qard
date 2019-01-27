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

class NewQardFormViewController: FormViewController {
    
    var qard: Qard = Qard();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Core Qard")
            <<< TextRow(){ row in
                row.title = "Qard Id"
                row.placeholder = "Enter text here"
                row.tag = "qardId"
                }.onChange {row in
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
                }.onChange {row in
                    self.qard.isPrivate = row.value ?? true;
            }
            +++ Section("Header")
            <<< TextRow(){ row in
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
            +++  MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                    header: "Multivalued TextField",
                                    footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") {
                                        $0.addButtonProvider = { section in
                                            return ButtonRow() { row in
                                                row.title = "Add Link"
                                                }.onCellSelection{ cell, row in
                                                    let newLinkFormViewController = NewLinkFormViewController()
                                                    self.navigationController?.pushViewController(newLinkFormViewController, animated: true)
                                            }
                                        }
                                        $0.multivaluedRowToInsertAt = { index in
                                            return NameRow() {
                                                $0.placeholder = "Tag Name"
                                            }
                                        }
                                        $0 <<< ButtonRow() { row in
                                            row.title = "Add Link"
                                            }.onCellSelection{ cell, row in
                                                let newLinkFormViewController = NewLinkFormViewController()
                                                self.navigationController?.pushViewController(newLinkFormViewController, animated: true)
                                                newLinkFormViewController.willMove(toParent: self)
                                        }
        }
        
        
        
        
    }
}
