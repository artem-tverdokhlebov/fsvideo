//
//  FSSwitchTableViewCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/26/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

typealias FSSwitchTableViewCellHandler = (cell: FSSwitchTableViewCell, value: Bool) -> Void

class FSSwitchTableViewCell: FSPredefinedTableViewCell {

    var switchHandler: FSSwitchTableViewCellHandler?
    var switcher: UISwitch?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.switcher = UISwitch()
        self.switcher?.addTarget(self, action: #selector(switched), forControlEvents: .ValueChanged)
        self.accessoryView = self.switcher
    }
    
    override func updateColors() {
        super.updateColors()
        self.switcher?.onTintColor = self.colors().primaryColor
    }
    
    override func updateCell() {
        
    }
    
    func switched() {
        self.switchHandler?(cell: self, value: self.switcher!.on)
    }
}
