//
//  UIViewControllerExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import UIImageColors

extension UIViewController {
    
    class func fromStoryboard(storyboard: UIStoryboard, identifier: String) -> UIViewController? {
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    func fromStoryboard(identifier: String) -> UIViewController? {
        return self.storyboard?.instantiateViewControllerWithIdentifier(identifier)
    }
    
    func updateDefaultColors() {
        self.updateColorsWithBundle(FSTheme.defaultColors())
    }
    
    func updateColorsWithBundle(colorBundle: FSColorBundle) {
        self.view.backgroundColor = colorBundle.backgroundColor
        self.tabBarController?.tabBar.tintColor = colorBundle.primaryColor
        self.tabBarController?.tabBar.barTintColor = colorBundle.backgroundColor
        self.navigationController?.navigationBar.tintColor = colorBundle.primaryColor
        self.navigationController?.navigationBar.barTintColor = colorBundle.backgroundColor
        
        let titleColor = colorBundle.backgroundColor.isDarkColor ? UIColor.whiteColor() : UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: titleColor]
                
        UISearchBar.appearance().tintColor = colorBundle.backgroundColor.isDarkColor ? colorBundle.backgroundColor : colorBundle.primaryColor
        UISearchBar.appearance().backgroundColor = colorBundle.backgroundColor
        UIBarButtonItem.appearanceWhenContainedInClass(UISearchBar.classForCoder()).setTitleTextAttributes([NSForegroundColorAttributeName: colorBundle.primaryColor], forState: .Normal)
        
        UIApplication.sharedApplication().statusBarStyle = colorBundle.statusBarStyle
    }
    
    func showNeworkAlert(error: NSError!) {
        let controller = UIAlertController(title: "Ошибка", message: "Пожалуйста проверьте соединение с Интернетом и повторите попытку позже.", preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
