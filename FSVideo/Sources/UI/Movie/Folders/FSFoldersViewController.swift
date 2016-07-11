//
//  FSFoldersViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSFoldersViewController: FSTableViewController {

    var movie: FSMovie!
    var folder: FSFolder! {
        didSet {
            self.children = (self.folder.children.allObjects as! [FSFolder]).sort({
                $0.0.name < $0.1.name
            })
        }
    }
    
    var fetchFolderContentRequest: FSFoldersRequest?
    var children: [FSFolder]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.folder.name
        
        refresh()
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
    }
    
    func refresh() {
        FSWebServices.sharedInstance.folderContent(self.movie, folder: self.folder, success: { (folders, files) in
            self.children = (self.folder.children.allObjects as! [FSFolder]).sort({
                $0.0.name < $0.1.name
            })
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }, failure: nil)
    }
    
    override func updateColors() {
        super.updateColors()
        self.refreshControl?.tintColor = self.colors().primaryColor
        self.tableView.separatorColor = self.colors().primaryColor
    }
}

extension FSFoldersViewController { // UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.children.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("folderCell") as! FSMovieFolderCell
        cell.selectedBackgroundView = UIView()
        cell.folder = self.children[indexPath.row]
        cell.colorsBundle = self.colors()
        if self.fetchFolderContentRequest?.folder?.folderId == cell.folder?.folderId {
            cell.state = .Processing
        } else {
            cell.state = .Disclosure
        }
        return cell
    }
}

extension FSFoldersViewController { // UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let folder = self.children[indexPath.row]
        self.fetchFolderContentAndPush(folder)
    }
    
    func fetchFolderContentAndPush(folder: FSFolder) {
        self.fetchFolderContent(folder) { (files) in
            var controller: UIViewController!
            if files.count > 0 {
                let filesController = self.fromStoryboard("FSFilesViewController") as! FSFilesViewController
                filesController.folder = folder
                filesController.movie = self.movie
                filesController.colorsBundle = self.colors()
                controller = filesController
            } else {
                let folderController = self.fromStoryboard("FSFoldersViewController") as! FSFoldersViewController
                folderController.folder = folder
                folderController.movie = self.movie
                folderController.colorsBundle = self.colors()
                controller = folderController
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func fetchFolderContent(folder: FSFolder, success: (files: [FSFile]!) -> Void) {
        if folder.children.count > 0 || folder.files.count > 0 {
            success(files: folder.files.allObjects as! [FSFile])
            return
        }
        self.fetchFolderContentRequest = FSWebServices.sharedInstance.folderContent(self.movie, folder: folder, success: { (folders, files) in
            self.fetchFolderContentRequest = nil
            self.tableView.reloadData()
            success(files: files)
        }) { (error) in
            self.fetchFolderContentRequest = nil
            self.tableView.reloadData()
            self.showNeworkAlert(error)
        } as? FSFoldersRequest
        self.tableView.reloadData()
    }
}
