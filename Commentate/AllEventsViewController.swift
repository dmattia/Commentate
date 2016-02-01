//
//  AllEventsViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class AllEventsViewController: UIViewController {
    
    @IBOutlet weak var myEventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Listen"
    }
}