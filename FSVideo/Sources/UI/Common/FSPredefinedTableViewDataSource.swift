//
//  FSPredefinedTableViewDataSource.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSPredefinedTableViewDataSource: NSObject {
    
    var sections = [FSPredefinedTableViewSection]()
    
    func addSection(section: FSPredefinedTableViewSection!) -> FSPredefinedTableViewSection! {
        self.sections.append(section)
        return section
    }
    
    func addSection(sectionName sectionName: String?) -> FSPredefinedTableViewSection! {
        let section = FSPredefinedTableViewSection(name: sectionName)
        self.sections.append(section)
        return section
    }
    
    func addCell(cell: FSPredefinedTableViewCell!) -> FSPredefinedTableViewCell {
        let section = self.sections[self.sections.count - 1]
        section.addCell(cell)
        return cell
    }
    
    func addCell(title: String?, detail: String?, colors: FSColorBundle, action: FSPredefinedTableViewCellClickHandler?) -> FSPredefinedTableViewCell {
        let cell = FSPredefinedTableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        cell.clickHandler = action
        cell.accessoryView = KMTableViewCellColoredAccessory(color: colors.primaryColor)
        cell.colorsBundle = colors
        let selectedColor = colors.backgroundColor.isDarkColor ? colors.backgroundColor.lightColor() : colors.backgroundColor.darkColor()
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView!.backgroundColor = selectedColor
        let section = self.sections[self.sections.count - 1]
        section.addCell(cell)
        return cell
    }
    
    func updateColors(colors: FSColorBundle) {
        for section in self.sections {
            for cell in section.cells {
                cell.colorsBundle = colors
            }
        }
    }
    
    func clear() {
        self.sections.removeAll()
    }
}

extension FSPredefinedTableViewDataSource: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.cells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let cell = section.cells[indexPath.row]
        return cell
    }
}

extension FSPredefinedTableViewDataSource: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        let cell = section.cells[indexPath.row]
        return cell.height()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        return section.headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = self.sections[section]
        return section.footerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.name
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.footerText
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.sections[section]
        let view = section.headerView
        let text = section.name
        return nil != view ? view!.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height : (nil != text ? -1 : 0.01)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = self.sections[section]
        let view = section.footerView
        let text = section.footerText
        var height: CGFloat = 0.01
        if nil != view {
            if let cell = view as? FSPredefinedTableViewCell {
                height = cell.staticHeight ?? cell.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
            } else {
                height = view!.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
            }
        } else if nil != text {
            height = -1
        }
        return height
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let predefinedCell = cell as! FSPredefinedTableViewCell
        predefinedCell.willDisplay()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = self.sections[indexPath.section]
        let cell = section.cells[indexPath.row]
        cell.clickHandler?(cell: cell)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let section = self.sections[indexPath.section]
        let cell = section.cells[indexPath.row]
        return cell.editable()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let section = self.sections[indexPath.section]
        let cell = section.cells[indexPath.row]
        return cell.editActions()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}
