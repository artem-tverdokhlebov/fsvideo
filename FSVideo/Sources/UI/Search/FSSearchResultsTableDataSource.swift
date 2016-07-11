//
//  FSSearchResultsTableDataSource.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/2/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSSearchResultsTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var searchResults: [FSMovie]?
    var searchRequest: FSWebRequest?
    
    var tableViewController: FSTableViewController
    var colors: FSColorBundle!
    var name: String?
    private(set) var source: Int32
    
    init(tableViewController: FSTableViewController, source: Int32, name: String?) {
        self.source = source
        self.tableViewController = tableViewController
        self.name = name
        super.init()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if FSConfig.sharedInstance.useService(self.source) {
            if nil != self.searchRequest {
                result = 1
            } else if nil != self.searchResults {
                result = max(1, self.searchResults!.count)
            }
        }
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var result : UITableViewCell? = nil
        
        if nil != self.searchRequest || self.searchResults?.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("loadingCell")!
            if nil != self.searchRequest {
                let indicator = UIActivityIndicatorView()
                indicator.startAnimating()
                indicator.color = self.colors.primaryColor
                cell.accessoryView = indicator
                cell.textLabel?.text = "Поиск..."
            } else {
                cell.accessoryView = nil
                cell.textLabel?.text = "Ничего не найдено"
            }
            cell.textLabel?.textColor = self.colors.primaryColor
            cell.backgroundColor = self.colors.backgroundColor
            cell.userInteractionEnabled = false
            result = cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as! FSMovieTableViewCell
            cell.movie = self.searchResults![indexPath.row]
            cell.colors = self.colors
            cell.state = .Disclosure
            result = cell
        }
        
        result!.selectedBackgroundView = UIView()
        result!.selectedBackgroundView!.backgroundColor = self.colors.backgroundColor.lightColor()
        return result!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let noResults = nil != self.searchResults && self.searchResults!.count == 0
        let isSearching = nil != self.searchRequest
        return isSearching || noResults ? 44.0 : 96.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if nil != self.searchResults {
            let controller = self.tableViewController.fromStoryboard("FSMovieViewController") as! FSMovieViewController
            let movie = self.searchResults![indexPath.row]
            controller.movie = movie
            
            let cell = self.tableViewController.tableView.cellForRowAtIndexPath(indexPath) as! FSMovieTableViewCell
            if cell.posterImageView.image != nil && movie.poster != nil {
                cell.state = .Processing
                let image = cell.posterImageView.image!
                image.getColors(100.0, completionHandler: { (colors: FSColorBundle) in
                    controller.colorsBundle = colors
                    cell.state = .Disclosure
                    self.tableViewController.navigationController?.pushViewController(controller, animated: true)
                })
            } else {
                self.tableViewController.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func startSearch(searchQuery: String) {
        self.searchResults = nil
        if searchQuery.length > 0 {
            self.searchRequest = FSWebServices.sharedInstance.search(searchQuery, source: self.source, success: { (response) in
                self.searchRequest = nil
                self.searchResults = response
                self.tableViewController.tableView.reloadData()
            }, failure: { (error) in
                self.searchRequest = nil
                self.tableViewController.tableView.reloadData()
                if self.source != FSMovie.SourceExUa {
                    // don't display alert for ex.ua. It is unstable
                    self.tableViewController.showNeworkAlert(error)
                }
            })
        }
    }
}
