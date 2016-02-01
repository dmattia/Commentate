//
//  MyEventsViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class MyEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myEventsTableView: UITableView!
    var myEvents : [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Events"
        
        self.myEventsTableView.delegate = self
        self.myEventsTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let query = PFQuery(className: "Event")
        query.whereKey("speaker", equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, error: NSError?) -> Void in
            self.myEvents = events
            self.myEventsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.myEvents?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        
        destinationViewController.event = self.myEvents![indexPath.row]
        
        self.presentViewController(destinationViewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MyEventsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MyEventsTableViewCell
        cell.selectionStyle = .None
        
        let event = self.myEvents![indexPath.row]
        
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
