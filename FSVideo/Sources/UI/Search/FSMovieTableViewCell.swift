//
//  FSMovieTableViewCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SDWebImage

class FSMovieTableViewCell: UITableViewCell {
    
    enum State {
        case Disclosure
        case Processing
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countrySectionLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var disclosureIndicator: KMTableViewCellColoredAccessory!
    
    var state: State = .Disclosure {
        didSet {
            if self.state == .Disclosure {
                self.disclosureIndicator.hidden = false
                self.activityIndicatorView.hidden = true
            } else {
                self.disclosureIndicator.hidden = true
                self.activityIndicatorView.hidden = false
                self.activityIndicatorView.startAnimating()
            }
        }
    }
    
    var colors: FSColorBundle? {
        didSet {
            updateColors()
        }
    }
    
    var movie: FSMovie? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        if self.movie != nil {
            if let poster = self.movie!.poster {
                let url = NSURL(string: poster)
                self.posterImageView.sd_setImageWithURL(url)
            } else {
                self.posterImageView.image = UIImage(named: "default_poster")
            }
            self.titleLabel.text = self.movie?.title
            
            if movie!.fromExUa {
                self.countrySectionLabel.text = movie?.movieDescription
                self.genresLabel.text = nil
                self.countrySectionLabel.numberOfLines = 3
            } else {
                let countries = self.movie?.countries.allObjects as! [FSCountry]
                let countryNames = countries.map({ $0.name! }) as [String]
                self.countrySectionLabel.numberOfLines = 1
                self.countrySectionLabel.text = countryNames.joinWithSeparator(", ") + " · " + self.movie!.section!
                
                let genres = self.movie?.genres.allObjects as! [FSGenre]
                let genreNames = genres.map({ $0.name! }) as [String]
                self.genresLabel.numberOfLines = 2
                self.genresLabel.text = genreNames.joinWithSeparator(", ")
            }
        }
    }
    
    func updateColors() {
        self.posterImageView.tintColor = self.colors?.primaryColor
        self.titleLabel.textColor = self.colors?.primaryColor
        self.countrySectionLabel.textColor = self.colors?.secondaryColor
        self.genresLabel.textColor = self.colors?.detailColor
        self.backgroundColor = self.colors?.backgroundColor
        self.selectedBackgroundView!.backgroundColor = self.colors?.backgroundColor.lightColor()
        self.disclosureIndicator.accessoryColor = self.colors?.primaryColor
        self.disclosureIndicator.highlightedColor = self.colors?.primaryColor
        self.activityIndicatorView.color = self.colors?.primaryColor
    }
}
