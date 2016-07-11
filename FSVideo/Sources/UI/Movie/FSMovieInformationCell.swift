//
//  FSMovieInformationCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSMovieInformationCell: FSMovieInfoCell {

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    
    @IBOutlet weak var titleInformationLabel: UILabel!
    @IBOutlet weak var titleSectionLabel: UILabel!
    @IBOutlet weak var titleGenresLabel: UILabel!
    @IBOutlet weak var titleCountriesLabel: UILabel!
    
    override func updateCell() {
        self.sectionLabel.text = self.movie.section!
        
        let countries = self.movie?.countries.allObjects as! [FSCountry]
        let countryNames = (countries.map({ $0.name! }) as [String]).sort(<)
        self.countriesLabel.text = countryNames.joinWithSeparator(", ")
        
        let genres = self.movie?.genres.allObjects as! [FSGenre]
        let genreNames = (genres.map({ $0.name! }) as [String]).sort(<)
        self.genresLabel.text = genreNames.joinWithSeparator(", ")
    }
    
    override func updateColors() {
        self.sectionLabel.textColor = self.colors().secondaryColor
        self.countriesLabel.textColor = self.colors().secondaryColor
        self.genresLabel.textColor = self.colors().secondaryColor
        self.titleGenresLabel.textColor = self.colors().primaryColor
        self.titleSectionLabel.textColor = self.colors().primaryColor
        self.titleCountriesLabel.textColor = self.colors().primaryColor
        self.titleInformationLabel.textColor = self.colors().primaryColor
    }
    
    override func height() -> CGFloat {
        return self.intrinsicContentSize().height
    }
}
