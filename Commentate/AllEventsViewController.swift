//
//  AllEventsViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class AllEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myEventsTableView: UITableView!
    var liveEvents : [PFObject]?
    var futureEvents : [PFObject]?
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Listen"
        
        self.myEventsTableView.dataSource = self
        self.myEventsTableView.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.myEventsTableView.addSubview(refreshControl)
        
        self.refresh(self)
    }
    
    func refresh(sender:AnyObject)
    {
        let query = PFQuery(className: "Event")
        query.whereKey("startTime", lessThan: NSDate())
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
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Live!"
        }
        return "Future Events"
    }
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        
        if(indexPath.section == 0) {
            destinationViewController.event = liveEvents![indexPath.row]
        } else {
            destinationViewController.event = futureEvents![indexPath.row]
        }
        
        self.presentViewController(destinationViewController, animated: true, completion: nil)
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
        cell.styleLabel.text = event["style"] as? String
        let randViewers = random() % 2000
        cell.viewersLabel.text = "\(randViewers)"
        
        // find the commentator Label
        let userId = event["speaker"] as? String
        do {
            let user = try PFQuery.getUserObjectWithId(userId!)
            cell.commentatorLabel.text = user.username
        } catch {
            cell.commentatorLabel.text = ""
        }
        
        return cell
    }
}