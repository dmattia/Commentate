//
//  CommentateViewController.swift
//  Commentate
//
//  Created by David Mattia on 2/2/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class CommentateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "Commentate")
        let logoView = UIImageView(image: logo)
        
        logoView.frame = CGRectMake(140, 0, 40, 40)
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.navigationItem.titleView = logoView
    }
}
