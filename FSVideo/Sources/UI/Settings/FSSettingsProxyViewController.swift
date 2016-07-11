//
//  FSSettingsProxyViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 7/2/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSSettingsProxyViewController: FSTableViewController {

    let dataSource = FSPredefinedTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Прокси", comment: "title")
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.build()
    }
    
    override func updateColors() {
        super.updateColors()
        self.dataSource.updateColors(self.colors())
    }
    
    func rebuild() {
        self.dataSource.clear()
        self.build()
        self.tableView.reloadData()
    }

    func build() {
        buildProxyUsageSection()
        if FSProxyConfiguration.isNeedProxy {
            buildProxySettingSection()
        }
    }
    
    func buildProxyUsageSection() {
        let section = self.dataSource.addSection(sectionName: "")
        section.footerText = "Использование прокси-сервера позволяет пользователям не из Украины пользоваться ресурсами сайтов ex.ua и fs.to и соответственно этим клиентом. Для пользователей с Украины использовать прокси не нужно. При использовании прокси могут быть перебои соединения. При использовании прокси онлайн-просмотр не доступен, только закачка."
        let coloriseCell = FSSwitchTableViewCell(style: .Default, reuseIdentifier: nil)
        coloriseCell.textLabel?.text = "Использовать прокси"
        coloriseCell.switcher?.on = FSProxyConfiguration.isNeedProxy
        coloriseCell.colorsBundle = self.colors()
        coloriseCell.switchHandler = ({ (_, on) in
            self.applyProxyChanges({ 
                FSProxyConfiguration.isNeedProxy = on
                self.rebuild()
            }, revert: {
                coloriseCell.switcher?.on = !on
            })
        })
        section.addCell(coloriseCell)
    }
    
    func buildProxySettingSection() {
        let section = self.dataSource.addSection(sectionName: "")
        section.footerText = "Указаный прокси сервер должен быть подключен через SOCKS 4"
        let hostCell = FSTextFieldTableViewCell(style: .Default, reuseIdentifier: nil)
        hostCell.titleLabel.text = "Host"
        hostCell.textField.text = FSProxyConfiguration.host
        hostCell.colorsBundle = self.colors()
        var editingClosure: FSTextFieldTableViewCell.handler = ({ (_, value) in
            self.applyProxyChanges({
                FSProxyConfiguration.host = value
            }, revert: {
                hostCell.textField.text = FSProxyConfiguration.host
            })
        })
        hostCell.editingClosure = editingClosure
        hostCell.endEditingClosure = editingClosure
        section.addCell(hostCell)
        
        let portCell = FSTextFieldTableViewCell(style: .Default, reuseIdentifier: nil)
        portCell.titleLabel.text = "Port"
        portCell.textField.text = "\(FSProxyConfiguration.port)"
        portCell.colorsBundle = self.colors()
        portCell.textField.keyboardType = .NumberPad
        editingClosure = ({ (_, value) in
            if let port = Int(value) {
                self.applyProxyChanges({
                    FSProxyConfiguration.port = port
                }, revert: {
                    portCell.textField.text = "\(FSProxyConfiguration.port)"
                })
            }
        })
        portCell.editingClosure = editingClosure
        portCell.endEditingClosure = editingClosure
        section.addCell(portCell)
        
        let actionCell = FSPredefinedTableViewCell(style: .Default, reuseIdentifier: nil)
        actionCell.textLabel?.textAlignment = .Center
        actionCell.textLabel?.font = UIFont.boldSystemFontOfSize(actionCell.textLabel!.font.pointSize)
        actionCell.textLabel?.text = "Сбросить настройки"
        actionCell.colorsBundle = self.colors()
        actionCell.clickHandler = ({ (_) in
            self.applyProxyChanges({
                FSProxyConfiguration.host = FSProxyConfiguration.defaultHost
                FSProxyConfiguration.port = FSProxyConfiguration.defaultPort
                hostCell.textField.text = FSProxyConfiguration.host
                portCell.textField.text = "\(FSProxyConfiguration.port)"
            }, revert: {
                
            })
        })
        section.addCell(actionCell)
    }
    
    
    func applyProxyChanges(changes: dispatch_block_t, revert: dispatch_block_t) {
        let hasActiveDownloads = FSItemLinkResolver.sharedInstance.linkInfos.count > 0
        if hasActiveDownloads {
            let alertController = UIAlertController(title: "Активные Закачки", message: "Сейчас качаются несколько файлов. Для вступления изменений закачки надо отменить. Отменять?", preferredStyle: .Alert)
            let actionAccept = UIAlertAction(title: "Отменить Закачки", style: .Destructive, handler: { (_) in
                let infos = FSItemLinkResolver.sharedInstance.linkInfos.values
                for info in infos {
                    FSItemLinkResolver.sharedInstance.cancel(info.file)
                }
                changes()
                FSItemLinkResolver.sharedInstance.configureManager()
            })
            let actionCancel = UIAlertAction(title: "Не Отменять", style: .Cancel, handler: { (_) in
                revert()
            })
            alertController.addAction(actionAccept)
            alertController.addAction(actionCancel)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            changes()
            FSItemLinkResolver.sharedInstance.configureManager()
        }
    }
}
