//
//  FSSettingsContentViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/3/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSSettingsContentViewController: FSTableViewController {

    let dataSource = FSPredefinedTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Контент", comment: "title")
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.build()
    }
    
    func build() {
        buildFsSection()
        buildExSection()
    }
    
    func buildFsSection() {
        let fsSection = self.dataSource.addSection(sectionName: "FS.TO")
        let fsToCell = FSSwitchTableViewCell(style: .Default, reuseIdentifier: nil)
        fsToCell.textLabel?.text = "Поиск по FS.TO"
        fsToCell.switcher?.on = FSConfig.sharedInstance.useFsTo
        fsToCell.colorsBundle = self.colors()
        fsToCell.switchHandler = ({ (_, on) in
            FSConfig.sharedInstance.useFsTo = on
        })
        fsSection.addCell(fsToCell)
    }
    
    func buildExSection() {
        let exSection = self.dataSource.addSection(sectionName: "EX.UA")
        let exUaCell = FSSwitchTableViewCell(style: .Default, reuseIdentifier: nil)
        let useExUa = FSConfig.sharedInstance.useExUa
        exUaCell.textLabel?.text = "Поиск по EX.UA"
        exUaCell.switcher?.on = useExUa
        exUaCell.colorsBundle = self.colors()
        exUaCell.switchHandler = ({ (_, on) in
            FSConfig.sharedInstance.useExUa = on
        })
        exSection.addCell(exUaCell)
    }
}
