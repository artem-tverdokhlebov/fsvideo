//
//  FSMovieCastCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSMovieCastCell: FSMovieInfoCell {
    
    @IBOutlet weak var titleCastLabel: UILabel!
    @IBOutlet weak var titleActorsLabel: UILabel!
    @IBOutlet weak var titleDirectorsLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    
    override func updateCell() {
        let actors = self.movie?.cast.allObjects as! [FSHuman]
        let actorNames = (actors.map({ $0.name! }) as [String]).sort(<)
        self.actorsLabel.text = actorNames.joinWithSeparator("\n")
        
        let directors = self.movie?.directors.allObjects as! [FSHuman]
        let directorNames = (directors.map({ $0.name! }) as [String]).sort(<)
        self.directorsLabel.text = directorNames.joinWithSeparator("\n")
    }
    
    override func updateColors() {
        self.actorsLabel.textColor = self.colors().secondaryColor
        self.directorsLabel.textColor = self.colors().secondaryColor
        self.titleCastLabel.textColor = self.colors().primaryColor
        self.titleActorsLabel.textColor = self.colors().primaryColor
        self.titleDirectorsLabel.textColor = self.colors().primaryColor
    }
    
    override func height() -> CGFloat {
        return self.intrinsicContentSize().height
    }
}
