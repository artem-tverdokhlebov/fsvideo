//
//  FSFileCellTableDelegate.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/1/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSFileCellTableDelegate: NSObject {
    
    var files = [FSFile]()
    var tableViewController: FSTableViewController?
    var updateTimer: NSTimer?
    var colors: FSColorBundle!
    var tableView: UITableView? {
        return tableViewController?.tableView
    }
    
    override init() {
        super.init()
        self.updateTimer =  NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(progressUpdateTimerTick), userInfo: nil, repeats: true)
    }
    
    deinit {
        self.updateTimer?.invalidate()
    }
    
    func setupCell(cell: FSFileCell, indexPath: NSIndexPath) {
        cell.selectedBackgroundView = UIView()
        let file = self.files[indexPath.row]
        cell.colorsBundle = self.colors
        cell.file = file
        #if EXTENDED
            cell.downloadHandler = {(cell) in
                self.downloadFile(file)
            }
        #endif
        
        cell.playHandler = {(cell) in
            #if EXTENDED
                self.tableViewController?.playVideo(file, online: !(file.isExtended))
            #else
                self.playOnlineFile(file)
            #endif
        }
        
        cell.clickHandler = {(cell) in
            #if EXTENDED
                if file.isExtended {
                    self.tableViewController?.playVideo(file, online: false)
                }
            #else
                self.playOnlineFile(file)
            #endif
        }
        
        
        cell.editActionsHandler = {(cell) in
            self.editActionsForRowAtIndexPath(indexPath)
        }
        
        cell.editableHandler = {(cell) in
            #if EXTENDED
                return self.editActionsForRowAtIndexPath(indexPath).count > 0
            #else
                return false
            #endif
        }
    }
    
    func editActionsForRowAtIndexPath(indexPath: NSIndexPath) -> [UITableViewRowAction] {
        var actions = [UITableViewRowAction]()
        let file = self.files[indexPath.row]
        
        #if EXTENDED
        let downloadInfo = FSItemLinkResolver.sharedInstance.linkInfos[file.localURL.lastPathComponent!]
        if downloadInfo != nil {
            let cancelAction = UITableViewRowAction(style: .Destructive, title: "Отмена", handler: { (_, _) in
                FSItemLinkResolver.sharedInstance.cancel(file)
                self.tableView?.editing = true
                self.tableView?.editing = false
            })
            actions.append(cancelAction)
        } else if file.isExtended {
            let deleteAction = UITableViewRowAction(style: .Destructive, title: "Удалить", handler: { (_, _) in
                file.delete()
                self.tableView?.editing = true
                self.tableView?.editing = false
            })
            actions.append(deleteAction)
        }
            
        if !file.isExtended && !FSProxyConfiguration.isNeedProxy {
            let onlineAction = UITableViewRowAction(style: .Default, title: "Online") { (_, _) in
                self.playOnlineFile(file)
            }
            
            var color = self.colors.primaryColor
            if !color.isDarkColor {
                color = self.colors.secondaryColor
            }
            if !color.isDarkColor {
                color = self.colors.backgroundColor.lightColor()
            }
            if !color.isDarkColor {
                color = UIColor(hexString: "4f5de9")
            }
            onlineAction.backgroundColor = color
            actions.append(onlineAction)
        }
        #endif
        
        return actions
    }
    
    func selectRowAtIndexPath(indexPath: NSIndexPath) {
        let file = self.files[indexPath.row]
        #if EXTENDED
            if file.isExtended {
                self.tableViewController?.playVideo(file, online: false)
            }
        #else
            self.playOnlineFile(file)
        #endif
    }

    func progressUpdateTimerTick() {
        if let visibleRows = self.tableView?.indexPathsForVisibleRows {
            for indexPath in visibleRows {
                let cell = self.tableView?.cellForRowAtIndexPath(indexPath) as? FSFileCell
                cell?.updateCell()
            }
        }
    }
    #if EXTENDED
    func downloadFile(file: FSFile) {
        FSItemLinkResolver.sharedInstance.downloadFile(file, progress: nil, success: nil, failure: { (error) in
            self.tableViewController?.showNeworkAlert(error)
        })
    }
    #endif
    
    func playOnlineFile(file: FSFile) {
        FSItemLinkResolver.sharedInstance.fetchLink(file, force: true, success: {
            self.tableViewController?.playVideo(file, online: true)
        }, failure: { (error) in
            self.tableViewController?.showNeworkAlert(error)
        })
    }
}
