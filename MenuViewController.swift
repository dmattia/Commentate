//
//  MenuViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MenuViewController: CommentateViewController, PFLogInViewControllerDelegate {
    let btnName = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LogInController")
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logoutClicked(sender: AnyObject) {
        PFUser.logOut()
        self.displayLogin()
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            if(PFUser.currentUser() == nil) {
                self.displayLogin()
            } else {
                
            }
        })
    }
    
}
