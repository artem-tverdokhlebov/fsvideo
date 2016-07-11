//
//  FSDownloadsViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import CoreData


class FSDownloadsViewController: FSTableViewController {
    
    @IBOutlet weak var freeSpaceLabel: UILabel!
    @IBOutlet weak var freeSpaceProgressView: UIProgressView!
    
    var downloads: [FSItemLinkInfo]!
    var downloaded: [FSFile]!
    var didAddOrRemoveFiles = false
    var updateTimer: NSTimer?
    var documentInteractionController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Закачки"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didUpdateDownloads), name: kFSDidFinishedDownloadNotification, object: nil)
        self.didUpdateDownloads()
        self.startProgressUpdateTimer()
        self.shouldRestrictInsets = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(ofSize: CGSizeMake(26.0, 26.0), progress: 0.0, paused: true, color: UIColor.whiteColor()).imageWithRenderingMode(.AlwaysTemplate)
        self.tabBarItem = UITabBarItem(title: "Закачки", image: image, tag: 3)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateColors()
        self.didUpdateDownloads()
    }
    
    override func updateColors() {
        super.updateColors()
        self.freeSpaceProgressView.progressTintColor = self.colors().primaryColor
        self.freeSpaceProgressView.trackTintColor = self.colors().backgroundColor.isDarkColor ? self.colors().backgroundColor.lightColor() : self.colors().backgroundColor.darkColor()
        self.freeSpaceLabel.textColor = self.colors().primaryColor
    }
    
    func didUpdateDownloads() {
        self.downloads = FSItemLinkResolver.sharedInstance.linkInfos.map({ (_, info) -> FSItemLinkInfo in
            info
        })
        self.downloaded = FSLocalStorage.sharedInstance.files(withPredicate: NSPredicate(format: "isExtended = YES")).sort({
            if $0.0.movie!.title! != $0.1.movie!.title! {
                return $0.0.movie!.title! < $0.1.movie!.title!
            }
            if $0.0.season != $0.1.season {
                return $0.0.season < $0.1.season
            }
            if $0.0.seriesNumber != $0.1.seriesNumber {
                return $0.0.seriesNumber < $0.1.seriesNumber
            }
            if $0.0.sourceOrder != $0.1.sourceOrder {
                return $0.0.sourceOrder < $0.1.sourceOrder
            }
            if $0.0.fileName! != $0.1.fileName! {
                return $0.0.fileName! < $0.1.fileName!
            }
            return $0.0.fileId! < $0.1.fileId!
        })
        self.tableView.reloadData()
    }
    
    deinit {
        self.updateTimer?.invalidate()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func startProgressUpdateTimer() {
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(progressUpdateTimerTick), userInfo: nil, repeats: true)
    }
    
    func progressUpdateTimerTick() {
        let visibleRows = self.tableView.indexPathsForVisibleRows
        for indexPath in visibleRows! {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FSDownloadedFileCell
            cell.updateCell()
        }
        
        let free = UIDevice.currentDevice().freeDiskSpace()
        let total = UIDevice.currentDevice().totalDiskSpace()
        self.freeSpaceProgressView.progress = 1.0 - free.floatValue / total.floatValue
        self.freeSpaceLabel.text = "Свободно " + String.fromBytes(free.longLongValue) + " из " + String.fromBytes(total.longLongValue)
    }
}

extension FSDownloadsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 == section ? self.downloads.count : self.downloaded.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fileCell") as! FSDownloadedFileCell
        cell.selectedBackgroundView = UIView()
        cell.colorsBundle = self.colors()
        if 0 == indexPath.section {
            cell.file = self.downloads[indexPath.row].file
        } else {
            cell.file = self.downloaded[indexPath.row]
        }
        cell.clickHandler = {(_) in
            if cell.file.isExtended {
                self.playVideo(cell.file, online: false)
            }
        }
        return cell
    }
}

extension FSDownloadsViewController {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var file: FSFile!
        if 0 == indexPath.section {
            file = self.downloads[indexPath.row].file
        } else {
            file = self.downloaded[indexPath.row]
        }
        if file.isExtended {
            self.playVideo(file, online: false)
        } else {
            let controller = UIAlertController(title: "Не Прилетел", message: "Этот файл еще летит, подождите пока долетит.", preferredStyle: UIAlertControllerStyle.Alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        
        var file: FSFile
        if 0 == indexPath.section {
            file = self.downloads[indexPath.row].file
        } else {
            file = self.downloaded[indexPath.row]
        }
        
        let deleteAction = UITableViewRowAction(style: .Destructive, title: indexPath.section == 0 ? "Отменить" : "Удалить") { (_, _) in
            if 0 == indexPath.section {
                FSItemLinkResolver.sharedInstance.cancel(file)
                self.downloads.removeAtIndex(indexPath.row)
            } else {
                file.delete()
                self.downloaded.removeAtIndex(indexPath.row)
            }
            self.updateTimer?.invalidate()
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            self.startProgressUpdateTimer()
        }
        actions.append(deleteAction)
        
        if file.isExtended {
            let shareAction = UITableViewRowAction(style: .Default, title: "Открыть в") { (_, _) in
                let cell = self.tableView.cellForRowAtIndexPath(indexPath)!
                self.documentInteractionController = UIDocumentInteractionController(URL: file.localURL)
                self.documentInteractionController?.presentOpenInMenuFromRect(cell.bounds, inView: cell, animated: true)
            }
            
            var color = self.colors().primaryColor
            if !color.isDarkColor {
                color = self.colors().secondaryColor
            }
            if !color.isDarkColor {
                color = self.colors().backgroundColor.lightColor()
            }
            if !color.isDarkColor {
                color = UIColor(hexString: "4f5de9")
            }
            shareAction.backgroundColor = color
            actions.append(shareAction)
        }
        
        return actions
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}
