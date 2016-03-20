//
//  EventViewController.swift
//  Commentate
//
//  Created by David Mattia on 2/1/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class EventViewController: CommentateViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    @IBOutlet weak var viewerCountView: UIView!
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var waveFormView: SCSiriWaveformView!
    var event : PFObject?
    var backgroundMusic : AVAudioPlayer?
    var displaylink : CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // add one to the number of events the current user has viewed
        //let currentCount = PFUser.currentUser()!["eventsViewed"] as! NSNumber
        //PFUser.currentUser()!["eventsViewed"] = currentCount.integerValue + 1
        //PFUser.currentUser()!.saveInBackground()
        
        // Add bar button to upper right to even out logo
        let rightButton = UIBarButtonItem(title: "        ", style: .Plain, target: self, action: "clicked:")
        self.navigationItem.rightBarButtonItem = rightButton
        
        // Round the corners of the profile picture and viewer count views
        self.viewerCountView.layer.cornerRadius = self.viewerCountView.frame.size.width / 2
        self.viewerCountView.layer.masksToBounds = true
        self.profilePictureView.layer.cornerRadius = self.viewerCountView.frame.size.width / 2
        self.profilePictureView.layer.masksToBounds = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("View disappeared")
        self.backgroundMusic?.stop()
        
        self.displaylink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.nameLabel.text = self.event?["title"] as? String
        //self.descriptionTextView.text = self.event?["description"] as? String
        let randomViewerCount = random() % 2000
        self.listenersLabel.text = "\(randomViewerCount)"
        
        if let music = backgroundMusic {
            print("\(music) already playing")
        } else {
            self.backgroundMusic = self.setupAudioPlayerWithFile("DBlast", type: "mp3")
            self.backgroundMusic?.meteringEnabled = true
            self.backgroundMusic?.volume = 0.3
        }
        backgroundMusic?.play()
        
        self.displaylink = CADisplayLink(target: self, selector: "updateMeters:")
        displaylink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func updateMeters(sender: AnyObject) {
        self.backgroundMusic?.updateMeters()
        
        if let decibels = self.backgroundMusic?.averagePowerForChannel(0) {
            var normalizedValue : Float
            if(decibels < -60 || decibels == 0) {
                normalizedValue = 0.0
            } else {
                normalizedValue = powf((powf(10.0, 0.05 * decibels) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0);
            }
            self.waveFormView.updateWithLevel(CGFloat(normalizedValue))
        }
        
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
}
