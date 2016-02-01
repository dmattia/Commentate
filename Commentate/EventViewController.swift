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

class EventViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    var event : PFObject?
    var backgroundMusic : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.nameLabel.text = self.event?["title"] as? String
        let randomViewerCount = random() % 2000
        self.listenersLabel.text = "\(randomViewerCount) Listeners"
        
        if let backgroundMusic = self.setupAudioPlayerWithFile("love story", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
        backgroundMusic?.volume = 0.3
        backgroundMusic?.play()
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
