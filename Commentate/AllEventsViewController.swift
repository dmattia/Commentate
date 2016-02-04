//
//  AllEventsViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse
import Foundation

class AllEventsViewController: CommentateViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myEventsTableView: UITableView!
    var liveEvents : [PFObject]?
    var futureEvents : [PFObject]?
    var refreshControl:UIRefreshControl!
    let pictureOptions = ["soccer", "gloves", "basketball", "default"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Force logout for demo purposes only
        PFUser.logOut()
        
        self.title = "Listen"
        let myColor = UIColor(colorLiteralRed: 39.0/255.0, green: 40.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        self.myEventsTableView.backgroundColor = myColor
        self.myEventsTableView.backgroundView?.backgroundColor = myColor
        
        self.myEventsTableView.dataSource = self
        self.myEventsTableView.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.myEventsTableView.addSubview(refreshControl)
        
        self.refresh(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            if(PFUser.currentUser() == nil) {
                self.displayLogin()
            }
        })
    }
    
    func displayLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LogInController")
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func refresh(sender:AnyObject)
    {
        let query = PFQuery(className: "Event")
        //query.whereKey("startTime", lessThan: NSDate()) Removing this will grab all events
        // would order by viewers if it were actually in the database
        // right now, viewers is a random number decided at runtime
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, error: NSError?) -> Void in
            self.liveEvents = events
            self.myEventsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        let futureQuery = PFQuery(className: "Event")
        futureQuery.whereKey("startTime", greaterThan: NSDate())
        futureQuery.orderByAscending("startTime")
        futureQuery.findObjectsInBackgroundWithBlock { (events: [PFObject]?, error: NSError?) -> Void in
            self.futureEvents = events
            self.myEventsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Hardcoded to 1 for now. Support is full for 2,
        // but we are only demoing with 1 (live events, not future)
        return 1
    }
    
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Live!"
        }
        return "Future Events"
    }
    */    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            if let count = self.liveEvents?.count {
                return count
            }
        } else {
            if let count = self.futureEvents?.count {
                return count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AllEventsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AllEventsTableViewCell
        cell.selectionStyle = .None
        
        var event : PFObject
        if(indexPath.section == 0) {
            event = self.liveEvents![indexPath.row]
        } else {
            event = self.futureEvents![indexPath.row]
        }
        cell.eventTitleLabel.text = event["title"] as? String
        let randViewers = random() % 2000
        cell.viewersLabel.text = "\(randViewers) Viewers"
        
        // find the commentator Label
        let userId = event["speaker"] as? String
        do {
            let user = try PFQuery.getUserObjectWithId(userId!)
            cell.commentatorLabel.text = user.username
        } catch {
            cell.commentatorLabel.text = ""
        }
        
        // set random picture
        let imageName = self.pictureOptions[Int(arc4random_uniform(UInt32(self.pictureOptions.count)))]
        let image = UIImage(named: imageName)
        cell.pictureView.image = image
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController as! EventViewController
        destinationViewController.event = liveEvents![(self.myEventsTableView.indexPathForSelectedRow?.row)!]
    }
}