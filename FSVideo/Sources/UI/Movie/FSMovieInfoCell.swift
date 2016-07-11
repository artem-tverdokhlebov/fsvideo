//
//  FSMovieInfoCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit


class FSMovieInfoCell: FSPredefinedTableViewCell {
    
    var movie: FSMovie! {
        didSet {
            self.updateCell()
        }
    }
    
    override func willDisplay() {
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
    }
}
