//
//  FSMovieSegmentControlCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSMovieSegmentControlCell: FSMovieInfoCell {

    @IBOutlet weak var segmentControl: UISegmentedControl!

    override func height() -> CGFloat {
        return 44.0
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(super.intrinsicContentSize().width, self.height())
    }
}
