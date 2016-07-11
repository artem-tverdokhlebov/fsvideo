//
//  FSVideoPlayerController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SnapKit


class FSVideoPlayerController: AVPlayerViewController {

    var file: FSFile!
    var isPlaying = false
    var label: UILabel!
    
    class func player(file: FSFile!, online: Bool) -> FSVideoPlayerController {
        let player = FSVideoPlayerController()
        player.file = file
        
        let url = online ? file.onlineURL! : file.localURL
        player.player = AVPlayer(URL: url)
        
        print("Start playing video from url ", url)
        
        return player
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGesture.direction = .Right
        self.view.addGestureRecognizer(rightSwipeGesture)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        leftSwipeGesture.direction = .Left
        self.view.addGestureRecognizer(leftSwipeGesture)
        
        self.label = UILabel()
        self.label.alpha = 0.0
        self.label.font = UIFont.boldSystemFontOfSize(25.0)
        self.view.addSubview(self.label)
        self.label.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(timeJumped), name: AVPlayerItemTimeJumpedNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        savePosition()
    }
    
    func timeJumped() {
        savePosition()
    }
    
    func savePosition() {
        if self.isPlaying {
            self.file.duration = self.player!.currentItem!.duration.seconds
            self.file.pauseSecond = self.player!.currentTime().seconds
            FSLocalStorage.sharedInstance.saveChanges()
        }
    }
    
    func play() {
        self.player!.play()
        let time = CMTime(seconds: file.pauseSecond, preferredTimescale: 1)
        self.player!.seekToTime(time)
        self.isPlaying = true
    }
    
    func swipedRight(notification: NSNotification) {
        if let currentItem = self.player?.currentItem {
            let length = currentItem.asset.duration.seconds
            let current = self.player!.currentTime().seconds
            let diff = min(length - current - 1, 30)
            self.displayOverlayText(String(format: "%.0lfs ⇒", diff))
            let time = CMTime(seconds: current + diff, preferredTimescale: 1)
            self.player?.seekToTime(time)
        }
    }
    
    func swipedLeft(notification: NSNotification) {
        let current = self.player!.currentTime().seconds
        let diff = min(current + 1, 10)
        self.displayOverlayText(String(format: "⇐ %.0lfs", diff))
        let time = CMTime(seconds: current - diff, preferredTimescale: 1)
        self.player?.seekToTime(time)
    }
    
    func displayOverlayText(text: String) {
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -1.0,
        ]
        self.label.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
        
        self.label.alpha = 0.0
        UIView.animateWithDuration(0.2, animations: { 
            self.label.alpha = 1.0
        }) { (_) in
            UIView.animateWithDuration(0.2, delay: 0.2, options: .LayoutSubviews, animations: {
                self.label.alpha = 0.0
            }, completion: nil)
        }
    }
}

extension UIViewController {

    func playVideo(file: FSFile!, online: Bool) {
        let player = FSVideoPlayerController.player(file, online: online)
        self.presentViewController(player, animated: true) {
            player.play()
        }
    }
}
