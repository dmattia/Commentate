//
//  CreateEventViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelPushed(sender: AnyObject) {
        print("Cancelling...")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePushed(sender: AnyObject) {
        
    }
}
