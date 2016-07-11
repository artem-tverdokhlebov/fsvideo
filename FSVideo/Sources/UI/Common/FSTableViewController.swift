//
//  FSTableViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/22/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SnapKit


class FSTableViewController: UIViewController {
    
    init(style: UITableViewStyle) {
        self.tableViewStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tableViewStyle = .Plain
        super.init(coder: aDecoder)
    }
    
    var colorsBundle: FSColorBundle? {
        didSet {
            self.updateColors()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    var shouldRestrictInsets = true
    private var tableViewStyle: UITableViewStyle
    
    func colors() -> FSColorBundle! {
        return self.colorsBundle != nil ? self.colorsBundle! : FSTheme.defaultColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nil == self.tableView {
            self.tableView = UITableView(frame: CGRectZero, style: self.tableViewStyle)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.view.addSubview(self.tableView)
            self.tableView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(self.view)
            })
            self.shouldRestrictInsets = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
        if self.shouldRestrictInsets {
            self.tableView.contentInset = UIEdgeInsetsZero
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.shouldRestrictInsets {
            self.tableView.contentInset = UIEdgeInsetsZero
        }
    }
    
    func updateColors() {
        self.updateColorsWithBundle(self.colors())
        self.tableView.indicatorStyle = self.colors().primaryColor.isDarkColor ? .Black : .White
        if self.tableView.style == .Grouped {
            self.tableView.backgroundColor = self.colors().backgroundColor.newColorWithDifference(-0.03)
        } else {
            self.tableView.backgroundColor = self.colors().backgroundColor
            for sectionIndex in 0 ..< self.tableView.numberOfSections {
                let header = self.tableView.headerViewForSection(sectionIndex)
                header?.textLabel?.textColor = self.colors().primaryColor
                header?.backgroundView?.backgroundColor = self.colors().backgroundColor.newColorWithDifference(0.03)
            }
        }
    }
}

extension FSTableViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        updateColors()
    }
}

extension FSTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
