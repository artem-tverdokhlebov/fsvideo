//
//  FSAboutFooterCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/26/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSAboutFooterCell: FSPredefinedTableViewCell {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func updateColors() {
        super.updateColors()
        self.backgroundColor = UIColor.clearColor()
    }
}
