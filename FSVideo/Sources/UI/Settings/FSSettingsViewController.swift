//
//  FSSettingsViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/19/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import MessageUI

class FSSettingsViewController: FSTableViewController {
    
    var mailComposer: MFMailComposeViewController?
    let dataSource = FSPredefinedTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Настройки", comment: "title")
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.build()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Настройки", comment: "title"), image: UIImage(named: "settings"), tag: 4)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateColors()
    }
    
    override func updateColors() {
        super.updateColors()
        self.dataSource.updateColors(self.colors())
    }
    
    func build() {
        self.dataSource.addSection(sectionName: "Общие")
        self.dataSource.addCell("Тема", detail: nil, colors: self.colors()) { (cell) in
            let controller = FSSettingsThemeViewController(style: .Grouped)
            controller.colorsBundle = self.colors()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if FSConfig.sharedInstance.canChangeService() {
            self.dataSource.addCell("Контент", detail: nil, colors: self.colors()) { (cell) in
                let controller = FSSettingsContentViewController(style: .Grouped)
                controller.colorsBundle = self.colors()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        #if EXTENDED
            self.dataSource.addCell("Прокси-сервер", detail: nil, colors: self.colors()) { (cell) in
                let controller = FSSettingsProxyViewController(style: .Grouped)
                controller.colorsBundle = self.colors()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        #endif
        
        let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        self.dataSource.addSection(sectionName: "Информация")
        self.dataSource.addCell("Про приложение", detail: nil, colors: self.colors()) { (cell) in
            let controller = self.fromStoryboard("FSAboutViewController") as! FSAboutViewController
            controller.colorsBundle = self.colors()
            self.navigationController?.pushViewController(controller, animated: true)            
        }
        self.dataSource.addCell("Поделиться приложением", detail: nil, colors: self.colors()) { (cell) in
            #if EXTENDED
                let link = "https://f0x.pw/fsvideo"
            #else
                let link = "http://appstore.com/fsvideo"
            #endif
            let text = "\(appName) - FS.to и EX.ua в твоем iPhone!"
            let controller = UIActivityViewController(activityItems: [text, link], applicationActivities: nil)
            self.presentViewController(controller, animated: true, completion: nil)
        }
        self.dataSource.addCell("Обратная связь", detail: nil, colors: self.colors()) { (cell) in
            if MFMailComposeViewController.canSendMail() {
                self.createMailComposer()
                self.mailComposer!.setSubject("\(appName): Обратная связь")
                self.mailComposer!.setToRecipients(["\(appName) Support <fermerasb@gmail.com>"])
                self.presentViewController(self.mailComposer!, animated: true, completion: nil)
            } else {
                let controller = UIAlertController(title: "Не Настроена Почта", message: "Чтоб связаться с автором приложения, Вам нужно сначала настроить приложение 'Почта', подключив хотя бы один почтовый ящик. Для этого зайдите в Системные Настройки -> Почта -> Добавить Аккаунт.", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }
    
    func createMailComposer() {
        if MFMailComposeViewController.canSendMail() && self.mailComposer == nil {
            self.mailComposer = MFMailComposeViewController()
            self.mailComposer?.mailComposeDelegate = self
            self.mailComposer?.modalPresentationStyle = .FormSheet
        }
    }
}

extension FSSettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dispatch_async(dispatch_get_main_queue()) {
            controller.dismissViewControllerAnimated(true, completion: nil)
            self.mailComposer = nil
            self.createMailComposer()
        }
    }
}
