//
//  ProfileViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: CommentateViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var yourEventsLabelView: UIView!
    @IBOutlet weak var purpleBackground: UIView!
    @IBOutlet weak var myEventCount: UILabel!
    @IBOutlet weak var myListenerCount: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var myEventsTableView: UITableView!
    var myEvents : [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        
        self.yourEventsLabelView.layer.cornerRadius = self.yourEventsLabelView.frame.width / 2
        self.yourEventsLabelView.layer.masksToBounds = true
        
        self.myEventsTableView.delegate = self
        self.myEventsTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.usernameLabel.text = PFUser.currentUser()!.username
        
        let query = PFQuery(className: "Event")
        query.whereKey("speaker", equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, error: NSError?) -> Void in
            self.myEvents = events
            self.myEventsTableView.reloadData()
            
            let count = events?.count
            self.myEventCount.text = "Total Events: \(count!)"
            let listenerCount = (random() % 2000) * Int((count!))
            self.myListenerCount.text = "Total Listeners: \(listenerCount)"
            self.myEventsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.myEvents?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "myEventCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        cell!.selectionStyle = .None
        
        let event = self.myEvents![indexPath.row]
        cell?.textLabel!.text = event["title"] as? String
        
        return cell!
    }
}