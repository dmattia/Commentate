//
//  LogInViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!,
            password:self.passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("Login failed")
            }
        }
    }
}
