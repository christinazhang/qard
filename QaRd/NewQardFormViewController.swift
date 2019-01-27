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
        
        let swatches = Constants.gradients.map { (gradient) -> GradientSwatchView in
            let gradientSwatchView = GradientSwatchView()
            gradientSwatchView.gradient = gradient
            return gradientSwatchView
        }
        
        form +++ Section("Core Qard")
            <<< TextRow(){ row in
                row.title = "QaRd ID"
                row.placeholder = "e.g. Gaming, Business, Social"
                row.tag = "qardId"
                }.onChange { row in
                    self.qard.id = row.value ?? "";
                }
            //  Custom color palette example
//            <<< GradientPickerRow() { row in
//                row.title = "Gradient"
//            }
            <<< PushRow<Int>(){ row in
                row.title = "Gradient"
                row.options = [1, 2, 3, 4, 5, 6]
                }.onPresent({ (from, to) in
                    to.selectableRowCellUpdate = { cell, row in
                        
                        cell.contentView.addSubview(swatches[0])
                    }
                })
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

public final class GradientPickerCell: Cell<[CGColor]>, CellType {
    public var titleLabel: UILabel = UILabel()
    public var selectedSwatchView: GradientSwatchView = GradientSwatchView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    public override func setup() {
        super.setup()
        
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.selectedSwatchView)
        self.selectedSwatchView.gradient = Constants.gradients[4]
    }
    
}

public class GradientSwatchView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var gradient: [CGColor]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        if let gradient = self.gradient {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = gradient
            gradientLayer.frame = self.bounds
            self.layer.addSublayer(gradientLayer)
        }
    }
    
}


//public final class GradientPickerRow: Row<GradientPickerCell>, RowType {
//    required public init(tag: String?) {
//        super.init(tag: tag)
//    }
//}

public final class GradientPickerRow : Row<PushSelectorCell<GradientSwatchView>>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
//        displayValueFor = {
//            guard let location = $0 else { return "" }
//            let fmt = NumberFormatter()
//            fmt.maximumFractionDigits = 4
//            fmt.minimumFractionDigits = 4
//            let latitude = fmt.string(from: NSNumber(value: location.coordinate.latitude))!
//            let longitude = fmt.string(from: NSNumber(value: location.coordinate.longitude))!
//            return  "\(latitude), \(longitude)"
//        }
    }
}
    
//    override public func customDidSelect() {
//        super.customDidSelect()
//        guard !isDisabled else { return }
//
//        let vc = MapViewController() { _ in }
//        vc.row = self
//        cell.formViewController()?.navigationController?.pushViewController(vc, animated: true)
//        vc.onDismissCallback = { _ in
//            vc.navigationController?.popViewController(animated: true)
//        }
//    }
//}
