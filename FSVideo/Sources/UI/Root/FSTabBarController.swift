//
//  FSTabBarController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControllers()
    }
    
    func setupControllers() {
        var controllers = [UIViewController]()
        controllers.append(fromStoryboard("FSFavoritesViewController")!)    
        controllers.append(fromStoryboard("FSRecentsViewController")!)
        controllers.append(fromStoryboard("FSSearchViewController")!)
        #if EXTENDED
            controllers.append(UIViewController.fromStoryboard(UIStoryboard(name: "Extended", bundle: nil), identifier: "FSDownloadsViewController")!)
        #endif
        controllers.append(fromStoryboard("FSSettingsViewController")!)
        
        self.viewControllers = controllers.map({ (controller) in
            UINavigationController(rootViewController: controller)
        })
        if FSLocalStorage.sharedInstance.movies(withPredicate: NSPredicate(format: "isFavorite == YES")).count == 0 {
            self.selectedIndex = 2
        }
    }
}
