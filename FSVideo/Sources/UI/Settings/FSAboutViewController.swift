//
//  FSAboutViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/22/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSAboutViewController: FSTableViewController {
    
    let dataSource = FSPredefinedTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Про авторов", comment: "title")
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.build()
    }
    
    override func updateColors() {
        super.updateColors()
    }

    func build() {
        let section = self.dataSource.addSection(sectionName: "")
        self.dataSource.addCell("Лицензии", detail: nil, colors: self.colors()) { (cell) in
            let controller = FSTextViewController()
            let path = NSBundle.mainBundle().pathForResource("TOS", ofType: "rtf")
            let text = try! NSMutableAttributedString(fileURL: NSURL(fileURLWithPath: path!), options: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType], documentAttributes: nil)
            text.addAttribute(NSForegroundColorAttributeName, value: self.colors().primaryColor, range: NSMakeRange(0, text.length))
            controller.attributedString = text
            controller.colors = self.colors()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        self.dataSource.addCell("Про автора", detail: nil, colors: self.colors()) { (cell) in
            let controller = FSTextViewController()
            let path = NSBundle.mainBundle().pathForResource("About", ofType: "rtf")
            let text = try! NSMutableAttributedString(fileURL: NSURL(fileURLWithPath: path!), options: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType], documentAttributes: nil)
            text.addAttribute(NSForegroundColorAttributeName, value: self.colors().primaryColor, range: NSMakeRange(0, text.length))
            controller.attributedString = text
            controller.colors = self.colors()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        self.dataSource.addCell("Другие приложения автора", detail: nil, colors: self.colors()) { (cell) in
            let url = "https://itunes.apple.com/ua/developer/alexey-bodnya/id936782445"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
        self.dataSource.addCell("Facebook page", detail: nil, colors: self.colors()) { (cell) in
            let url = "https://www.facebook.com/fsvideo4ios"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
        self.dataSource.addCell("Vkontakte page", detail: nil, colors: self.colors()) { (cell) in
            let url = UIApplication.sharedApplication().canOpenURL(NSURL(string: "vk://")!) ? "vk://vk.com/fsvideo_ios" : "https://vk.com/fsvideo_ios"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
        
        let bundleInfo = NSBundle.mainBundle().infoDictionary!
        let version = bundleInfo["CFBundleShortVersionString"] as! String
        let build = bundleInfo["CFBundleVersion"] as! String
        let footerCell = self.tableView.dequeueReusableCellWithIdentifier("footer") as! FSAboutFooterCell
        footerCell.colorsBundle = self.colors()
        footerCell.appNameLabel.text = bundleInfo["CFBundleName"] as? String
        footerCell.appVersionLabel.text = "\(version).\(build)"
        footerCell.staticHeight = 44.0
        section.footerView = footerCell
    }
}
