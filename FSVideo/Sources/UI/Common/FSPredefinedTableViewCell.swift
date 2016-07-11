//
//  FSPredefinedTableViewCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit


typealias FSPredefinedTableViewCellClickHandler = (cell: FSPredefinedTableViewCell) -> Void
typealias FSPredefinedTableViewCellEditableHandler = (cell: FSPredefinedTableViewCell) -> Bool
typealias FSPredefinedTableViewCellEditActionsHandler = (cell: FSPredefinedTableViewCell) -> [UITableViewRowAction]?

class FSPredefinedTableViewCell: UITableViewCell {
    
    var staticHeight: CGFloat?
    var colorsBundle: FSColorBundle? {
        didSet {
            self.updateColors()
        }
    }
    
    func colors() -> FSColorBundle! {
        return self.colorsBundle != nil ? self.colorsBundle! : FSTheme.defaultColors()
    }
    
    func updateColors() {
        self.backgroundColor = self.colors().backgroundColor
        self.textLabel?.textColor = self.colors().primaryColor
        self.detailTextLabel?.textColor = self.colors().secondaryColor
        
        let color = self.backgroundColor!.isDarkColor ? self.backgroundColor!.lightColor() : self.backgroundColor!.darkColor()
        self.selectedBackgroundView?.backgroundColor = color
        
        if (self.accessoryView as? KMTableViewCellColoredAccessory) != nil {
            self.accessoryView = KMTableViewCellColoredAccessory(color: self.colors().primaryColor)
        }
    }
    
    func updateCell() {
        
    }
    
    func height() -> CGFloat {
        return staticHeight != nil ? staticHeight! : 44.0
    }
    
    func willDisplay() {
        
    }
    
    func didDisplay() {
        
    }
    
    var editableHandler: FSPredefinedTableViewCellEditableHandler?
    func editable() -> Bool {
        return nil != editableHandler ? editableHandler!(cell: self) : false
    }
    
    var editActionsHandler: FSPredefinedTableViewCellEditActionsHandler?
    func editActions() -> [UITableViewRowAction]? {
        return nil != editActionsHandler ? editActionsHandler!(cell: self) : nil
    }
    
    var clickHandler: FSPredefinedTableViewCellClickHandler?
}
