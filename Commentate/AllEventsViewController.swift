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
    var events : [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Listen"
        
        self.myEventsTableView.dataSource = self
        self.myEventsTableView.delegate = self
        
        let query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, error: NSError?) -> Void in
            self.events = events
            self.myEventsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.events?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AllEventsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AllEventsTableViewCell
        
        let event = self.events![indexPath.row]
        cell.eventTitleLabel.text = event["title"] as? String
        //cell.commentatorLabel.text = event["]
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