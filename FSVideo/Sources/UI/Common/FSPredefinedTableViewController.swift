//
//  FSPredefinedTableViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 7/3/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSPredefinedTableViewController: FSTableViewController {

    let dataSource = FSPredefinedTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.build()
    }
    
    func build() {
        
    }
    
    func rebuild() {
        self.dataSource.clear()
        self.build()
        self.tableView.reloadData()
    }
}
