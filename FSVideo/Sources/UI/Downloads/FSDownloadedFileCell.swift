//
//  FSDownloadedFileCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/18/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SnapKit

class FSDownloadedFileCell: FSPredefinedTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var disclosureIndicator: KMTableViewCellColoredAccessory!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var file: FSFile! {
        didSet {
            self.updateCell()
        }
    }
    
    override func updateCell() {
        if let poster = self.file.movie!.poster {
            let url = NSURL(string: poster)
            self.posterImageView.sd_setImageWithURL(url)
        } else {
            self.posterImageView.image = UIImage(named: "default_poster")
        }
        self.titleLabel.text = self.file.movie!.title
        
        if self.file.season != 0 || self.file.seriesNumber != 0 {
            self.secondLabel.text = "Сезон \(self.file.season) Серия \(self.file.seriesNumber)"
        } else {
            self.secondLabel.text = self.file.fileName!
        }
        self.thirdLabel.text = self.file.folder?.name
        if self.file.duration > 0 {
            let leftSeconds = self.file.duration - self.file.pauseSecond
            let leftMinutes = Int(leftSeconds) / 60
            if self.thirdLabel.text != nil {
                self.thirdLabel.text! += " - \(leftMinutes) мин. осталось"
            } else {
                self.thirdLabel.text = "\(leftMinutes) мин. осталось"
            }
        }
        
        self.activityIndicatorView.hidden = true
        self.disclosureIndicator.hidden = true
        self.progressButton.hidden = true
        self.playButton.hidden = true
        
        let linkInfo = FSItemLinkResolver.sharedInstance.linkInfos[file.localURL.lastPathComponent!]
        if nil != linkInfo {
            if nil != linkInfo?.download {
                let download = (linkInfo?.download)!
                let progress = download.progress
                let image = UIImage(ofSize: CGSizeMake(27.0, 27.0), progress: Double(progress), paused: download.isSuspended, color: self.colors().primaryColor)
                self.progressButton.setImage(image, forState: .Normal)
                self.progressButton.hidden = false
                self.thirdLabel.text = String.fromBytes(download.totalBytesWritten) + " из " + String.fromBytes(download.totalBytesExpectedToWrite)
            } else {
                assert(nil != linkInfo?.fetchOperation)
                self.activityIndicatorView.hidden = false
                self.thirdLabel.text = "Получение ссылки"
            }
        } else if file.isExtended {
            self.playButton.hidden = false
        }
    }
    
    override func updateColors() {
        self.posterImageView.tintColor = self.colors()?.primaryColor
        self.titleLabel.textColor = self.colors().primaryColor
        self.secondLabel.textColor = self.colors().secondaryColor
        self.thirdLabel.textColor = self.colors().detailColor
        self.backgroundColor = self.colors().backgroundColor
        
        self.disclosureIndicator.accessoryColor = self.colors().primaryColor
        self.disclosureIndicator.highlightedColor = self.colors().primaryColor
        self.activityIndicatorView.color = self.colors().primaryColor
        self.progressButton.tintColor = self.colors().primaryColor
        self.playButton.tintColor = self.colors().primaryColor
        
        self.backgroundColor = self.colors().backgroundColor
        let color = self.backgroundColor!.isDarkColor ? self.backgroundColor!.lightColor() : self.backgroundColor!.darkColor()
        self.selectedBackgroundView!.backgroundColor = color
    }
    
    @IBAction func pauseContinuePearing(sender: AnyObject) {
        if let linkInfo = FSItemLinkResolver.sharedInstance.linkInfos[file.localURL.lastPathComponent!] {
            let download = (linkInfo.download)!
            if download.isSuspended {
                download.resume()
            } else {
                download.suspend()
            }
        }
    }
    
    @IBAction func play(sender: AnyObject) {
        self.clickHandler?(cell: self)
    }
}
