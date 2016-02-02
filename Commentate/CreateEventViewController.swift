//
//  CreateEventViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: CommentateViewController  {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelPushed(sender: AnyObject) {
        print("Cancelling...")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePushed(sender: AnyObject) {
        let newEvent = PFObject(className: "Event")
        newEvent.setObject(self.titleTextField.text!, forKey: "title")
        newEvent.setObject(self.descriptionTextField.text!, forKey: "description")
        newEvent.setObject(PFUser.currentUser()!.objectId!, forKey: "speaker")
        newEvent.saveInBackground()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
