//
//  ProfileViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var myEventsTableView: UITableView!
    @IBOutlet weak var purpleBackground: UIView!
    @IBOutlet weak var blueBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        
        self.purpleBackground.layer.cornerRadius = 25
        self.blueBackground.layer.cornerRadius = 25
        self.purpleBackground.layer.masksToBounds = true
        self.blueBackground.layer.masksToBounds = true
    }
}