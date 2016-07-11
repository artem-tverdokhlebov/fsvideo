//
//  FSMovieHeaderCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSMovieHeaderCell: FSMovieInfoCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    
    var tableView: UITableView!
    var tapOnPosterHandler: FSPredefinedTableViewCellClickHandler?
    
    override func updateCell() {
        if let poster = self.movie!.poster {
            self.posterButton.hidden = true
            let posterURL = NSURL(string: poster)
            self.posterImageView.sd_setImageWithURL(posterURL, completed: { (_, error, _, _) in
                if let image = self.posterImageView.image {
                    self.posterButton.hidden = false
                    self.posterButton.imageView?.contentMode = .ScaleAspectFit
                    self.posterButton.setImage(image, forState: .Normal)
                    self.posterImageView.image = nil
                }
            })
        } else {
            self.posterImageView.image = UIImage(named: "default_poster")
            self.posterButton.hidden = true
        }
        
        if self.movie.screen != nil {
            let screenURL = NSURL(string: self.movie!.screen!)
            self.backgroundImageView.sd_setImageWithURL(screenURL, completed: { (image: UIImage?, error: NSError?, _, _) in
                if nil != image && nil == error {
                    let size = self.intrinsicContentSize()
                    self.contentView.frame = CGRectMake(0, 0, size.width, size.height)
                    self.tableView.reloadData()
                    self.backgroundImageView.appyFadeFrom(CGPointMake(0.5, 0.7), to: CGPointMake(0.5, 1.0))
                }
            })
        }
        
        self.titleLabel.text = self.movie.title
        
        if movie.source == FSMovie.SourceFsTo {
            let years = (self.movie.years.allObjects as! [FSYear]).sort { (year1, year2) -> Bool in
                year1.year < year2.year
            }
            if years.count > 1 {
                let first = years.first!.year
                let last = years[years.count - 1].year
                self.yearsLabel.text = String(first) + " - " + String(last)
            } else {
                let year = years.first!.year
                self.yearsLabel.text = String(year)
            }
        } else {
            self.yearsLabel.text = nil
        }
        
        let size = self.intrinsicContentSize()
        self.contentView.frame = CGRectMake(0, 0, size.width, size.height)
    }
    
    override func updateColors() {
        if self.movie!.poster == nil {
            self.posterButton.tintColor = self.colors().primaryColor
            self.posterImageView.tintColor = self.colors().primaryColor
        }
        self.titleLabel.textColor = self.colors().primaryColor
        self.yearsLabel.textColor = self.colors().secondaryColor
    }
    
    override func height() -> CGFloat {
        return self.movie.screen != nil ? 240.0 : 152.0
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(super.intrinsicContentSize().width, height())
    }
    
    @IBAction func didTapOnPoster(sender: AnyObject) {
        self.tapOnPosterHandler?(cell: self)
    }
}
