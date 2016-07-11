//
//  FSFilesViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FSFilesViewController: FSTableViewController {
    
    var movie: FSMovie!
    var folder: FSFolder! {
        didSet {
            self.files = (self.folder.files.allObjects as! [FSFile]).sort({
                $0.0.fileName < $0.1.fileName
            })
        }
    }
    
    var files: [FSFile]!
    var filesDelegate = FSFileCellTableDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.folder.name
        self.filesDelegate.tableViewController = self
        self.filesDelegate.files = self.files
        
        refresh()
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
    }
    
    func refresh() {
        FSWebServices.sharedInstance.folderContent(self.movie, folder: self.folder, success: { (folders, files) in
            self.files = (self.folder.files.allObjects as! [FSFile]).sort({
                $0.0.fileName < $0.1.fileName
            })
            self.filesDelegate.files = self.files
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }, failure: nil)
    }
    
    override func updateColors() {
        super.updateColors()
        self.refreshControl?.tintColor = self.colors().primaryColor
        self.filesDelegate.colors = self.colors()
        self.tableView.separatorColor = self.colors().primaryColor
        if let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows {
            for indexPath in indexPathsForVisibleRows {
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FSFileCell
                cell.colorsBundle = self.colors()
            }
        }
    }
}

extension FSFilesViewController { // UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fileCell") as! FSFileCell
        self.filesDelegate.setupCell(cell, indexPath: indexPath)
        return cell
    }
}

extension FSFilesViewController { // UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.filesDelegate.selectRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return self.filesDelegate.editActionsForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}
