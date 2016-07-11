//
//  FSPredefinedTableViewSection.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSPredefinedTableViewSection: NSObject {
    
    var name: String?
    var index: Int?
    var cells = [FSPredefinedTableViewCell]()
    var headerView: UIView?
    var footerView: UIView?
    var footerText: String?
    
    init(name: String?) {
        super.init()
        self.name = name
    }
    
    func addCell(cell: FSPredefinedTableViewCell!) -> FSPredefinedTableViewCell! {
        self.cells.append(cell)
        return cell
    }
    
    func insertCell(cell: FSPredefinedTableViewCell!, index: Int) -> FSPredefinedTableViewCell! {
        self.cells.insert(cell, atIndex: index)
        return cell
    }
    
    func removeCellAtIndex(index: Int) {
        if index > 0 && index < self.cells.count {
            self.cells.removeAtIndex(index)
        }
    }
    
    func clear() {
        self.cells.removeAll()
    }
}
