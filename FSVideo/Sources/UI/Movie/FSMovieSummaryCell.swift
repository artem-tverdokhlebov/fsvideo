//
//  FSMovieSummaryCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSMovieSummaryCell: FSMovieInfoCell {

    @IBOutlet weak var titleSummaryLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func updateCell() {
        if self.movie.movieDescription != nil {
            self.summaryLabel.text = self.movie.movieDescription!
        } else {
            self.summaryLabel.text = "Загрузка..."
        }
    }
    
    override func updateColors() {
        self.titleSummaryLabel.textColor = self.colors().primaryColor
        self.summaryLabel.textColor = self.colors().secondaryColor
    }
    
    override func height() -> CGFloat {
        return self.intrinsicContentSize().height
    }
}
