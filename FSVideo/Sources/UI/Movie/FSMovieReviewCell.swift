//
//  FSMovieReviewCell.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SwiftHEXColors

class FSMovieReviewCell: FSPredefinedTableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likesDislikesLabel: UILabel!
    
    var review: FSReview? {
        didSet {
            updateCell()
        }
    }
    
    override func willDisplay() {
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
    }
    
    override func updateCell() {
        self.commentLabel.text = self.review?.comment
        self.updateContentAndColors()
    }
    
    override func updateColors() {
        self.commentLabel.textColor = self.colors().secondaryColor
        self.updateContentAndColors()
    }
    
    func updateContentAndColors() {
        var color = self.colors()?.primaryColor
        if self.review?.movie?.source == FSMovie.SourceFsTo {
            let isDarkColor = nil != self.colors() ? self.colors().backgroundColor.isDarkColor : true
            let likesColor = isDarkColor ? UIColor(hexString: "95D64E")! : UIColor(hexString: "55970E")!
            let dislikesColor = isDarkColor ? UIColor(hexString: "ED4C60")! : UIColor(hexString: "BB0E23")!
            color = self.review!.positive ? likesColor : dislikesColor
            
            let likesString = NSAttributedString(string: "↑" + String(self.review!.likes) + " ", attributes: [NSForegroundColorAttributeName: likesColor])
            let dislikesString = NSAttributedString(string: "↓" + String(self.review!.dislikes), attributes: [NSForegroundColorAttributeName: dislikesColor])
            let likesDislikesString = NSMutableAttributedString()
            likesDislikesString.appendAttributedString(likesString)
            likesDislikesString.appendAttributedString(dislikesString)
            self.likesDislikesLabel.attributedText = likesDislikesString
        } else {
            self.likesDislikesLabel.text = nil
        }
        self.authorLabel.textColor = color
        self.dateLabel.textColor = color
        self.authorLabel.text = self.review!.authorName!
        self.dateLabel.text = self.review!.dateString!
    }
    
    override func height() -> CGFloat {
        return self.intrinsicContentSize().height
    }
}
