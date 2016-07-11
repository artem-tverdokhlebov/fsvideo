//
//  FSRecentsViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/18/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSRecentsViewController: FSMoviesListViewController {

    let kMaxRecentsCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "История"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = UIImage(named: "clock")
        self.tabBarItem = UITabBarItem(title: "История", image: icon, tag: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.movies = FSLocalStorage.sharedInstance.movies(withPredicate: NSPredicate(format: "lastUsedDate != nil")).sort({
            $0.0.lastUsedDate!.compare($0.1.lastUsedDate!) == .OrderedDescending
        })
        if self.movies!.count > kMaxRecentsCount {
            self.movies!.removeRange(kMaxRecentsCount ..< self.movies!.count)
        }
        self.tableView.reloadData()
    }
}
