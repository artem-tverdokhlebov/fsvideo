//
//  FSTextViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/23/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SnapKit

class FSTextViewController: UIViewController {

    var string: String?
    var attributedString: NSAttributedString?
    var textView: UITextView?
    
    var colors: FSColorBundle! = FSTheme.defaultColors() {
        didSet {
            self.updateColors()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView = UITextView()
        self.textView?.backgroundColor = UIColor.clearColor()
        self.textView?.editable = false
        if self.attributedString != nil {
            self.textView?.attributedText = self.attributedString
        } else if self.string != nil {
            self.textView?.text = self.string
        }
        self.view.addSubview(self.textView!)
        self.textView?.snp_makeConstraints(closure: { (make) in
            make.leading.equalTo(self.view.snp_leading)
            make.trailing.equalTo(self.view.snp_trailing)
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.bottom.equalTo(self.snp_bottomLayoutGuideTop)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateColors()
        self.textView?.contentInset = UIEdgeInsetsZero
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView?.contentInset = UIEdgeInsetsZero
    }
    
    func updateColors() {
        self.updateColorsWithBundle(self.colors)
        self.textView?.indicatorStyle = self.colors.primaryColor.isDarkColor ? .Black : .White
    }
}
