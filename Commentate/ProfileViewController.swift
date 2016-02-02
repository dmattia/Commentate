//
//  ProfileViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: CommentateViewController {
    
    @IBOutlet weak var purpleBackground: UIView!
    @IBOutlet weak var blueBackground: UIView!
    @IBOutlet weak var myEventCount: UILabel!
    @IBOutlet weak var myListenerCount: UILabel!
    @IBOutlet weak var listenedToCount: UILabel!
    @IBOutlet weak var timeListenedCount: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        
        self.purpleBackground.layer.cornerRadius = 25
        self.blueBackground.layer.cornerRadius = 25
        self.purpleBackground.layer.masksToBounds = true
        self.blueBackground.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.usernameLabel.text = PFUser.currentUser()!.username
        let listenedTo = PFUser.currentUser()!["eventsViewed"]
        self.listenedToCount.text = "Listened To: \(listenedTo)"
        
        let query = PFQuery(className: "Event")
        query.whereKey("speaker", equalTo: PFUser.currentUser()!.objectId!)
        query.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) -> Void in
            if(error == nil) {
                self.myEventCount.text = "Total Events: \(count)"
                let listenerCount = (random() % 2000) * Int(count)
                self.myListenerCount.text = "Total Listeners: \(listenerCount)"
            }
        }
    }
}