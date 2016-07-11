//
//  FSMovieViewController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import UIImageColors
import SDWebImage
import SnapKit
import IDMPhotoBrowser


class FSMovieViewController: FSTableViewController {
    
    let dataSource = FSPredefinedTableViewDataSource()
    var movie: FSMovie!
    var filesDelegate = FSFileCellTableDelegate()
    
    var headerCell: FSMovieHeaderCell?
    var segmentControlCell: FSMovieSegmentControlCell?
    var segmentControl: UISegmentedControl?
    var informationCell: FSMovieInformationCell?
    var summaryCell: FSMovieSummaryCell?
    var castCell: FSMovieCastCell?
    var favoriteButton: UIBarButtonItem?
    var didLoadAllReviews = false
    var commentsOffset: UInt = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.shouldRestrictInsets = false
        
        self.filesDelegate.tableViewController = self
        self.filesDelegate.files = (self.movie.files.allObjects as! [FSFile]).sort({
            $0.0.fileName < $0.1.fileName
        })
        
        self.movie!.lastUsedDate = NSDate()
        FSLocalStorage.sharedInstance.saveChanges()
        
        self.didLoadAllReviews = self.movie!.reviews.count < 10
        
        self.buildHeader()
        self.buildInformationSection()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        
        self.selectSection(0)
        self.updateUI()
        self.refreshUI(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let favoriteImage = self.movie.isFavorite ? "favorite_on" : "favorite_off"
        self.favoriteButton?.image = UIImage(named: favoriteImage)
        self.updateColors()
    }
    
    func refresh() {
        self.refreshUI(true)
    }
    
    func refreshUI(showAlert: Bool) {
        FSWebServices.sharedInstance.movieInfo(self.movie, success: { (movie) in
            self.fetchReviewsAndFolders(showAlert)
        }) { (error) in
            self.fetchReviewsAndFolders(showAlert)
        }
    }
    
    func fetchReviewsAndFolders(showAlert: Bool) {
        FSWebServices.sharedInstance.reviews(self.movie, offset: 0, success: { (reviews) in
            if self.movie.fromExUa {
                self.updateUI()
                self.refreshControl?.endRefreshing()
            } else {
                FSWebServices.sharedInstance.folderContent(self.movie, folder: nil, success: { (folders, files) in
                    self.updateUI()
                    self.refreshControl?.endRefreshing()
                    }, failure: { (error) in
                        self.refreshControl?.endRefreshing()
                        if showAlert {
                            self.showNeworkAlert(error)
                        }
                })
            }
        }, failure: { (error) in
            self.refreshControl?.endRefreshing()
            if showAlert {
                self.showNeworkAlert(error)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = self.movie.title
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}

// MARK: Update UI
extension FSMovieViewController {
    
    func selectSection(sectionNumber: Int) {
        let section = self.dataSource.sections.last!
        section.clear()
        switch sectionNumber {
            case 0:
                self.selectInformationSection()
            case 1:
                self.selectSectionReviews()
            case 2:
                self.selectSectionFiles()
            default: break
        }
        self.updateUI()
    }
    
    func updateUI() {
        self.headerCell?.updateCell()
        switch self.segmentControl!.selectedSegmentIndex {
            case 0:
                self.updateUIInformation()
            case 1:
                self.updateUIReviews()
            case 2:
                self.updateUIFiles()
            default: break
        }
        self.tableView.reloadData()
    }
    
    override func updateColors() {
        super.updateColors()
        self.filesDelegate.colors = self.colors()
        self.refreshControl?.tintColor = self.colors().primaryColor
        self.segmentControl?.tintColor = self.colors().primaryColor
        self.tableView.separatorColor = self.colors().primaryColor
        self.segmentControlCell?.backgroundColor = self.colors().backgroundColor
        
        self.headerCell?.updateColors()
        switch self.segmentControl!.selectedSegmentIndex {
            case 0:
                self.updateColorsInformation()
            case 1:
                self.updateColorsReviews()
            case 2:
                self.updateColorsFiles()
            default: break
        }
    }
}

// MARK: Header
extension FSMovieViewController {
    
    func buildHeader() {
        self.favoriteButton = UIBarButtonItem(image: nil, style: .Plain, target: self, action: #selector(changeFavorite))
        self.updateFavoriteButton()
        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItems = [self.favoriteButton!, shareButton]
        
        self.headerCell = self.tableView.dequeueReusableCellWithIdentifier("headerCell") as? FSMovieHeaderCell
        self.headerCell?.tableView = self.tableView
        self.headerCell?.movie = self.movie
        self.headerCell?.colorsBundle = self.colors()
        self.headerCell?.backgroundColor = UIColor.clearColor()
        self.headerCell?.tapOnPosterHandler = {(cell) in
            var urls = [String]()
            urls.append(self.movie.poster!)
            for image in (self.movie.images.allObjects as! [FSImage]) {
                urls.append(image.link!)
            }
            let photos = urls.map({ (urlString) -> IDMPhoto in
                let url = NSURL(string: urlString)
                let photo = IDMPhoto(URL: url)
                return photo
            })
            let browser = IDMPhotoBrowser(photos: photos, animatedFromView: self.headerCell!.posterButton.imageView)
            browser.scaleImage = self.headerCell!.posterButton.currentImage
            browser.displayActionButton = true
            browser.displayArrowButton = false
            browser.displayCounterLabel = true
            browser.displayDoneButton = false
            browser.useWhiteBackgroundColor = !self.colors().backgroundColor.isDarkColor
            self.presentViewController(browser, animated: true, completion: nil)
        }
        self.tableView.tableHeaderView = self.headerCell?.contentView
        
        let dataSection = FSPredefinedTableViewSection(name: nil)
        self.segmentControlCell = self.tableView.dequeueReusableCellWithIdentifier("segmentControl") as? FSMovieSegmentControlCell
        self.segmentControl = segmentControlCell?.segmentControl
        self.segmentControl?.addTarget(self, action: #selector(segmentControlDidChangeSelection), forControlEvents: .ValueChanged)
        segmentControlCell?.contentView.backgroundColor = self.colors().backgroundColor
        dataSection.headerView = segmentControlCell?.contentView
        self.dataSource.addSection(dataSection)
    }
    
    func segmentControlDidChangeSelection() {
        self.selectSection(self.segmentControl!.selectedSegmentIndex)
    }
    
    func share() {
        let link = self.movie.host + self.movie.link!
        let text = "\(self.movie.title!)\n"
        let controller = UIActivityViewController(activityItems: [text, link], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func changeFavorite() {
        self.movie.isFavorite = !self.movie.isFavorite
        FSLocalStorage.sharedInstance.saveChanges()
        self.updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        let imageName = self.movie.isFavorite ? "favorite_on" : "favorite_off"
        let image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        self.favoriteButton?.image = image
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.headerCell?.updateCell()
    }
}

// MARK: Information
extension FSMovieViewController {
    
    func buildInformationSection() {
        self.summaryCell = self.tableView.dequeueReusableCellWithIdentifier("summaryCell") as? FSMovieSummaryCell
        self.summaryCell?.movie = self.movie
        self.summaryCell?.colorsBundle = self.colors()
        if self.movie.source == FSMovie.SourceFsTo {
            self.informationCell = self.tableView.dequeueReusableCellWithIdentifier("informationCell") as? FSMovieInformationCell
            self.informationCell?.movie = self.movie
            self.informationCell?.colorsBundle = self.colors()
            self.castCell = self.tableView.dequeueReusableCellWithIdentifier("castCell") as? FSMovieCastCell
            self.castCell?.movie = self.movie
            self.castCell?.colorsBundle = self.colors()
        }
    }
    
    func selectInformationSection() {
        let section = self.dataSource.sections.last!
        if self.movie.source == FSMovie.SourceFsTo {
            section.addCell(self.informationCell)
        }
        section.addCell(self.summaryCell)
        if self.movie.source == FSMovie.SourceFsTo {
            section.addCell(self.castCell)
        }
    }
    
    func updateUIInformation() {
        self.informationCell?.updateCell()
        self.summaryCell?.updateCell()
        self.castCell?.updateCell()
    }
    
    func updateColorsInformation() {
        self.informationCell?.updateColors()
        self.summaryCell?.updateColors()
        self.castCell?.updateColors()
    }
}

// MARK: Reviews
extension FSMovieViewController {
    
    func selectSectionReviews() {
        let section = self.dataSource.sections.last!
        let reviews = (self.movie!.reviews.allObjects as! [FSReview]).sort({
            $0.0.date!.compare($0.1.date!) == .OrderedDescending
        })
        for review in reviews {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("reviewCell") as? FSMovieReviewCell
            cell?.review = review
            cell?.colorsBundle = self.colors()
            section.addCell(cell)
        }
        if !self.didLoadAllReviews {
            let actionCell = FSPredefinedTableViewCell(style: .Value1, reuseIdentifier: nil)
            actionCell.selectedBackgroundView = UIView()
            actionCell.colorsBundle = self.colors()
            actionCell.textLabel?.text = "Загрузить больше комментов"
            actionCell.clickHandler = {(cell) in
                self.updateReviews(cell)
            }
            section.addCell(actionCell)
        }
    }
    
    func updateUIReviews() {
        let section = self.dataSource.sections.last
        for cell in section!.cells {
            cell.updateCell()
        }
    }
    
    func updateColorsReviews() {
        let section = self.dataSource.sections.last
        for cell in section!.cells {
            cell.updateColors()
        }
    }
    
    func updateReviews(loadingCell: UITableViewCell) {
        loadingCell.textLabel?.text = "Загрузка..."
        let indicator = UIActivityIndicatorView()
        indicator.color = self.colors().primaryColor
        indicator.startAnimating()
        loadingCell.accessoryView = indicator
        FSWebServices.sharedInstance.reviews(self.movie, offset: self.commentsOffset, success: { (newReviews) in
            if self.movie.fromExUa {
                self.commentsOffset = self.commentsOffset + 1
            } else {
                self.commentsOffset = UInt(self.movie.reviews.count)
            }
            if self.segmentControl?.selectedSegmentIndex == 1 {
                if newReviews.count < 10 {
                    self.didLoadAllReviews = true
                }
                self.selectSection(1)
                var row = self.movie!.reviews.count
                if self.didLoadAllReviews {
                    row = row - 1
                }
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
        }, failure: { (error) in
            loadingCell.textLabel?.text = "Загрузить больше комментов"
            loadingCell.accessoryView = nil
            self.showNeworkAlert(error)
        })

    }
}

// MARK: Files
extension FSMovieViewController {
    
    func selectSectionFiles() {
        // deffer rebuild to updateUIFiles
    }
    
    func updateUIFiles() {
        let section = self.dataSource.sections.last!
        section.clear()
        if self.movie.fromExUa {
            let files = (self.movie!.files.allObjects as! [FSFile]).sort({
                $0.0.sourceOrder < $0.1.sourceOrder
            })
            self.filesDelegate.files = files
            for (index, _) in files.enumerate() {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("fileCell") as! FSFileCell
                self.filesDelegate.setupCell(cell, indexPath: NSIndexPath(forRow: index, inSection: 0))
                section.addCell(cell)
            }
        } else {
            let folders = (self.movie!.folders.allObjects as! [FSFolder]).filter({$0.parent == nil}).sort({
                $0.0.name < $0.1.name
            })
            for folder in folders {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("folderCell") as? FSMovieFolderCell
                cell?.folder = folder
                cell?.colorsBundle = self.colors()
                cell?.state = .Disclosure
                cell?.clickHandler = { (cell) in
                    self.downloadFolderContentAndPush(cell as! FSMovieFolderCell)
                }
                section.addCell(cell)
            }
        }
    }
    
    func updateColorsFiles() {
        let section = self.dataSource.sections.last
        for cell in section!.cells {
            cell.updateColors()
        }
    }
    
    func downloadFolderContentAndPush(cell: FSMovieFolderCell) {
        self.downloadFolderContent(cell) { (files) in
            var controller: UIViewController!
            if files.count > 0 {
                let filesController = self.fromStoryboard("FSFilesViewController") as! FSFilesViewController
                filesController.folder = cell.folder
                filesController.movie = self.movie
                filesController.colorsBundle = self.colors()
                controller = filesController
            } else {
                let folderController = self.fromStoryboard("FSFoldersViewController") as! FSFoldersViewController
                folderController.folder = cell.folder
                folderController.movie = self.movie
                folderController.colorsBundle = self.colors()
                controller = folderController
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func downloadFolderContent(cell: FSMovieFolderCell, success: (files: [FSFile]!) -> Void) {
        if cell.folder?.children.count > 0 || cell.folder?.files.count > 0 {
            success(files: cell.folder!.files.allObjects as! [FSFile])
            return
        }
        cell.state = .Processing
        FSWebServices.sharedInstance.folderContent(self.movie, folder: cell.folder, success: { (folders, files) in
            cell.state = .Disclosure
            success(files: files)
        }) { (error) in
            cell.state = .Disclosure
            self.showNeworkAlert(error)
        }
    }
}
