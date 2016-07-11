//
//  FSFavoritesViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/18/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSFavoritesViewController: FSMoviesListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Любимые"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = UIImage(named: "favorite_off")?.imageWithRenderingMode(.AlwaysTemplate)
        let iconSelected = UIImage(named: "favorite_on")?.imageWithRenderingMode(.AlwaysTemplate)
        self.tabBarItem = UITabBarItem(title: "Любимые", image: icon, selectedImage: iconSelected)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.movies = FSLocalStorage.sharedInstance.movies(withPredicate: NSPredicate(format: "isFavorite == YES")).filter({
            $0.title != nil
        }).sort({
            $0.0.title! < $0.1.title!
        })
        self.tableView.reloadData()
    }
}
