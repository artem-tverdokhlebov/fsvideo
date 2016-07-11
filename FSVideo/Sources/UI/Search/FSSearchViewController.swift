//
//  FSSearchViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import UIImageColors
import SDWebImage

class FSSearchViewController: FSTableViewController {
    
    final let kSearchDelaySeconds: NSTimeInterval = 0.5

    var searchBar: UISearchBar!
    var searchResults: [FSMovie]?
    var searchRequest: FSWebRequest?
    var searchDelayTimer: NSTimer?
    var dataSources = [FSSearchResultsTableDataSource]()
    var didLocalizeCancelButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.searchBar.backgroundImage = UIImage()
        self.tableView.tableHeaderView = self.searchBar
        self.title = "Поиск"
        
        self.dataSources = [
            FSSearchResultsTableDataSource(tableViewController: self, source: FSMovie.SourceFsTo, name: "FS.TO"),
            FSSearchResultsTableDataSource(tableViewController: self, source: FSMovie.SourceExUa, name: "EX.UA")
        ]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateColors()
        self.tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = UIImage(named: "search")
        self.tabBarItem = UITabBarItem(title: "Поиск", image: icon, tag: 2)
    }
    
    override func updateColors() {
        super.updateColors()
        for dataSource in self.dataSources {
            dataSource.colors = self.colors()
        }
        self.tableView.separatorColor = self.colors().secondaryColor
    }
    
    func localizeCancelButton() {
        self.searchBar.enumerateSubviewsWithBlock { (subview) in
            if let button = subview as? UIButton {
                button.setTitle("Отмена", forState: .Normal)
                self.searchBar.setNeedsLayout()
                self.searchBar.layoutIfNeeded()
                button.layer.removeAnimationForKey("opacity")
            }
        }
    }
}

extension FSSearchViewController { // UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
}

extension FSSearchViewController { // UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSources.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = self.dataSources[section]
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataSource = self.dataSources[indexPath.section]
        return dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}

extension FSSearchViewController { // UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dataSource = self.dataSources[indexPath.section]
        return dataSource.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataSource = self.dataSources[indexPath.section]
        dataSource.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        self.searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var activeSections = 0
        for dataSource in self.dataSources {
            activeSections += FSConfig.sharedInstance.useService(dataSource.source) ? 1 : 0
        }
        let dataSource = self.dataSources[section]
        let rows = dataSource.tableView(tableView, numberOfRowsInSection: section)
        return rows > 0 && activeSections > 1 ? dataSource.tableView(tableView, titleForHeaderInSection: section) : nil
    }
}

extension FSSearchViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchRequest?.cancel()
        self.searchDelayTimer?.invalidate()
        self.searchDelayTimer = NSTimer.scheduledTimerWithTimeInterval(kSearchDelaySeconds, target: self, selector: #selector(startSearch), userInfo: nil, repeats: false)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        if !(self.didLocalizeCancelButton) {
            self.localizeCancelButton()
            self.didLocalizeCancelButton = true
        }
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        let query = FSLocalStorage.sharedInstance.insertSearchQuery()
        query.searchQuery = searchBar.text
        FSLocalStorage.sharedInstance.saveChanges()
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func startSearch() {
        self.searchDelayTimer = nil
        let searchQuery = self.searchBar.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        for dataSource in self.dataSources {
            if FSConfig.sharedInstance.useService(dataSource.source) {
                dataSource.startSearch(searchQuery)
            }
        }
        self.tableView.reloadData()
    }
}
