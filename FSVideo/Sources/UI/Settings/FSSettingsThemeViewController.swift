//
//  FSSettingsThemeViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/22/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSSettingsThemeViewController: FSTableViewController {
    
    let dataSource = FSPredefinedTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Тема", comment: "title")
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.build()
    }
    
    override func updateColors() {
        super.updateColors()
        self.dataSource.updateColors(self.colors())
    }
    
    func build() {
        buildThemeSection()
        buildPersonalizeSection()
    }
    
    func buildThemeSection() {
        let section = self.dataSource.addSection(sectionName: "")
        let coloriseCell = FSSwitchTableViewCell(style: .Default, reuseIdentifier: nil)
        coloriseCell.textLabel?.text = "Использовать светлую тему"
        coloriseCell.switcher?.on = FSConfig.sharedInstance.useLightTheme
        coloriseCell.colorsBundle = self.colors()
        coloriseCell.switchHandler = ({ (_, on) in
            FSConfig.sharedInstance.useLightTheme = on
            self.colorsBundle = FSTheme.defaultColors()
            self.updateColors()
            self.tableView.reloadData()
        })
        section.addCell(coloriseCell)
    }
    
    func buildPersonalizeSection() {
        let section = self.dataSource.addSection(sectionName: "")
        let coloriseCell = FSSwitchTableViewCell(style: .Default, reuseIdentifier: nil)
        coloriseCell.textLabel?.text = "Персонализация"
        coloriseCell.switcher?.on = FSConfig.sharedInstance.shouldPersonalizeScreens
        coloriseCell.colorsBundle = self.colors()
        coloriseCell.switchHandler = ({ (_, on) in
            FSConfig.sharedInstance.shouldPersonalizeScreens = on
            self.updatePersonalizeSectionFooter(section)
        })
        section.addCell(coloriseCell)
        self.updatePersonalizeSectionFooter(section)
    }
    
    func updatePersonalizeSectionFooter(section: FSPredefinedTableViewSection) {
        if FSConfig.sharedInstance.shouldPersonalizeScreens {
            section.footerText = "Цвета оформления страниц для фильмов берутся из постера к фильму. Таким образом подчеркивается то, что каждый фильм уникальный и несет свою цветную гамму"
        } else {
            section.footerText = "Цвета оформления страниц везде соответствуют общей теме приложения"
        }
        self.tableView.reloadData()
    }
}
