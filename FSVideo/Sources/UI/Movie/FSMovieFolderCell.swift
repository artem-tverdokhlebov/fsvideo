//
//  FSMovieFolderCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSMovieFolderCell: FSPredefinedTableViewCell {
    
    enum State {
        case Disclosure
        case Processing
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var disclocureIndicator: KMTableViewCellColoredAccessory!
    
    var state: State = .Disclosure {
        didSet {
            if self.state == .Disclosure {
                self.disclocureIndicator.hidden = false
                self.activityIndicatorView.hidden = true
            } else {
                self.disclocureIndicator.hidden = true
                self.activityIndicatorView.hidden = false
                self.activityIndicatorView.startAnimating()
            }
        }
    }
    
    var folder: FSFolder? {
        didSet {
            self.updateCell()
        }
    }
    
    override func willDisplay() {
        self.selectedBackgroundView = UIView()
        self.userInteractionEnabled = true
        if nil != self.colors() {
            let backgroundColor = self.colors().backgroundColor
            let color = backgroundColor.isDarkColor ? backgroundColor.lightColor() : backgroundColor.darkColor()
            self.selectedBackgroundView!.backgroundColor = color
        }
    }
    
    override func updateCell() {
        self.titleLabel.text = self.folder?.name
        self.subtitleLabel.text = self.folder?.updateDateString
        self.detailTitleLabel.text = self.folder?.details
    }
    
    override func updateColors() {
        self.titleLabel.textColor = self.colors().primaryColor
        self.subtitleLabel.textColor = self.colors().secondaryColor
        self.detailTitleLabel.textColor = self.colors().secondaryColor
        self.activityIndicatorView.color = self.colors().primaryColor
        self.disclocureIndicator.highlightedColor = self.colors().primaryColor
        self.disclocureIndicator.accessoryColor = self.colors().primaryColor
        self.backgroundColor = self.colors().backgroundColor
        let color = self.backgroundColor!.isDarkColor ? self.backgroundColor!.lightColor() : self.backgroundColor!.darkColor()
        self.selectedBackgroundView!.backgroundColor = color
    }
}
