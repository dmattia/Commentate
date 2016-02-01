//
//  SignUpViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        let user = PFUser()
        user.username = self.usernameTextField.text!
        user.password = self.passwordTextField.text!
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Couldn't log it: \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
}
