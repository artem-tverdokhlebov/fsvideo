//
//  FSTextFieldTableViewCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 7/2/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SnapKit


class FSTextFieldTableViewCell: FSPredefinedTableViewCell {
    
    typealias handler = (cell: FSTextFieldTableViewCell, value: String) -> Void
    
    let titleLabel = UILabel()
    let textField = UITextField()
    
    var startEditingClosure: dispatch_block_t?
    var editingClosure: handler?
    var endEditingClosure: handler?

    override func willDisplay() {
        super.willDisplay()
        if self != self.textField.superview {
            self.textLabel?.text = " "
            self.addSubview(self.titleLabel)
            self.titleLabel.textAlignment = .Left
            self.titleLabel.setContentHuggingPriority(252, forAxis: .Horizontal)
            self.titleLabel.snp_makeConstraints(closure: { (make) in
                make.leading.equalTo(self.textLabel!.snp_leading)
                make.top.equalTo(self.snp_top)
                make.bottom.equalTo(self.snp_bottom)
            })
            self.addSubview(self.textField)
            self.textField.textAlignment = .Right
            self.textField.setContentHuggingPriority(249, forAxis: .Horizontal)
            self.textField.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
            self.textField.snp_makeConstraints(closure: { (make) in
                make.leading.equalTo(self.titleLabel.snp_trailing).offset(10.0)
                make.trailing.equalTo(self.snp_trailing).offset(-16.0)
                make.centerY.equalTo(self.snp_centerY)
            })
            self.textField.delegate = self
        }
    }
    
    override func updateColors() {
        super.updateColors()
        self.titleLabel.textColor = self.colors().primaryColor
        self.textField.textColor = self.colors().secondaryColor
    }
}

extension FSTextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.startEditingClosure?()
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.endEditingClosure?(cell: self, value: textField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.textFieldShouldEndEditing(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var value = textField.text!
        value = value.stringByReplacingCharactersInRange(range.toRange(value), withString: string)
        self.editingClosure?(cell: self, value: value)
        return true
    }
}
