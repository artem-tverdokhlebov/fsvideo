//
//  FSMoviesListViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/18/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import UIImageColors


class FSMoviesListViewController: FSTableViewController {
    
    var movies: [FSMovie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = self.colors().secondaryColor
    }
}

extension FSMoviesListViewController { // UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as! FSMovieTableViewCell
        cell.movie = self.movies![indexPath.row]
        cell.colors = self.colors()
        cell.state = .Disclosure
        cell.selectedBackgroundView = UIView()
        return cell
    }
}

extension FSMoviesListViewController { // UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if nil != self.movies {
            let controller = fromStoryboard("FSMovieViewController") as! FSMovieViewController
            let movie = self.movies![indexPath.row]
            controller.movie = movie
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FSMovieTableViewCell
            if cell.posterImageView.image != nil && movie.poster != nil {
                cell.state = .Processing
                cell.posterImageView.image?.getColors(100.0, completionHandler: { (colors: FSColorBundle) in
                    controller.colorsBundle = colors
                    cell.state = .Disclosure
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            } else {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
