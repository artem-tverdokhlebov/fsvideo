//
//  FSFileCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SnapKit


typealias FSMovieInfoCellActionHandler = (cell: FSFileCell) -> Void

class FSFileCell: FSPredefinedTableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var disclosureIndicator: KMTableViewCellColoredAccessory!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    var playHandler: FSMovieInfoCellActionHandler?
    
    var file: FSFile! {
        didSet {
            self.updateCell()
        }
    }
    
    #if EXTENDED
    var downloadButton: UIButton!
    var downloadHandler: FSMovieInfoCellActionHandler!
    var progressButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.downloadButton = UIButton()
        self.downloadButton.setImage(UIImage(named: "cloud"), forState: .Normal)
        self.downloadButton.addTarget(self, action: #selector(download), forControlEvents: .TouchUpInside)
        self.addSubview(downloadButton)
        self.downloadButton.snp_makeConstraints { (make) in
            make.center.equalTo(self.disclosureIndicator)
            make.width.equalTo(27.0)
            make.height.equalTo(27.0)
        }
        self.progressButton = UIButton()
        self.progressButton.addTarget(self, action: #selector(pauseContinueDownloading), forControlEvents: .TouchUpInside)
        self.addSubview(self.progressButton)
        self.progressButton.snp_makeConstraints { (make) in
            make.center.equalTo(self.disclosureIndicator)
            make.width.equalTo(30.0)
            make.height.equalTo(30.0)
        }
    }
    #endif
    
    override func updateCell() {
        self.fileNameLabel.text = self.file.fileName
        self.qualityLabel.text = self.file.quality
        self.activityIndicator.hidden = true
        self.disclosureIndicator.hidden = true
        self.playButton.hidden = true
        
        #if EXTENDED
            self.downloadButton?.hidden = true
            self.progressButton.hidden = true
            
            let downloadInfo = FSItemLinkResolver.sharedInstance.linkInfos[file.localURL.lastPathComponent!]
            if nil != downloadInfo {
                if nil != downloadInfo?.download {
                    let download = (downloadInfo?.download)!
                    let progress = download.progress
                    let image = UIImage(ofSize: CGSizeMake(27.0, 27.0), progress: Double(progress), paused: download.isSuspended, color: self.colors().primaryColor)
                    self.progressButton.setImage(image, forState: .Normal)
                    self.progressButton.hidden = false
                    self.qualityLabel.text = String.fromBytes(download.totalBytesWritten) + " из " + String.fromBytes(download.totalBytesExpectedToWrite)
                } else if nil != downloadInfo?.fetchOperation {
                    self.activityIndicator.hidden = false
                    self.activityIndicator.startAnimating()
                    self.qualityLabel.text = "Получение ссылки"
                } else {
                    FSItemLinkResolver.sharedInstance.cancel(self.file)
                }
            } else if file.isExtended {
                self.playButton.hidden = false
            } else {
                self.downloadButton?.hidden = false
            }
        #else
            self.playButton.hidden = false
        #endif
    }
    
    override func updateColors() {
        self.fileNameLabel.textColor = self.colors().primaryColor
        self.qualityLabel.textColor = self.colors().secondaryColor
        
        #if EXTENDED
            self.downloadButton?.imageView?.tintColor = self.colors().primaryColor
            self.progressButton.tintColor = self.colors().primaryColor
        #endif
        
        self.disclosureIndicator.accessoryColor = self.colors().primaryColor
        self.disclosureIndicator.highlightedColor = self.colors().primaryColor
        self.activityIndicator.color = self.colors().primaryColor
        self.playButton.tintColor = self.colors().primaryColor
        
        self.backgroundColor = self.colors().backgroundColor
        let color = self.backgroundColor!.isDarkColor ? self.backgroundColor!.lightColor() : self.backgroundColor!.darkColor()
        self.selectedBackgroundView!.backgroundColor = color
    }
    
    @IBAction func playOnline(sender: AnyObject) {
        self.playHandler?(cell: self)
    }
    
    #if EXTENDED
    func download() {
        self.downloadHandler?(cell: self)
    }
    
    func pauseContinueDownloading() {
        if let downloadInfo = FSItemLinkResolver.sharedInstance.linkInfos[file.localURL.lastPathComponent!] {
            let download = (downloadInfo.download)!
            if download.isSuspended {
                download.resume()
            } else {
                download.suspend()
            }
        }
    }
    #endif
}
