//
//  CreateEventViewController.swift
//  Commentate
//
//  Created by David Mattia on 1/31/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    var startTime: NSDate?
    var typePickerData = ["Sports", "Other"]
    var stylePickerData = ["Serious", "Funny"]
    let typePickerView: UIPickerView = UIPickerView()
    let stylePickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePickerView.dataSource = self
        typePickerView.delegate = self
        self.typeTextField.inputView = typePickerView
        self.typeTextField.text = typePickerData[0]
        
        stylePickerView.dataSource = self
        stylePickerView.delegate = self
        self.styleTextField.inputView = stylePickerView
        self.styleTextField.text = stylePickerData[0]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == stylePickerView) {
            return stylePickerData.count
        } else {
            return typePickerData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == stylePickerView) {
            return stylePickerData[row]
        } else {
            return typePickerData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == stylePickerView) {
            self.styleTextField.text = stylePickerData[row]
        } else {
            self.typeTextField.text = typePickerData[row]
        }
    }
    
    @IBAction func cancelPushed(sender: AnyObject) {
        print("Cancelling...")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func timeTextOpened(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        datePickerView.minuteInterval = 5
        datePickerView.minimumDate = NSDate()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("startTimeValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func startTimeValueChanged(sender:UIDatePicker) {
        self.startTime = sender.date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        self.timeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func savePushed(sender: AnyObject) {
        let newEvent = PFObject(className: "Event")
        newEvent.setObject(self.typeTextField.text!, forKey: "type")
        newEvent.setObject(self.titleTextField.text!, forKey: "title")
        newEvent.setObject(self.styleTextField.text!, forKey: "style")
        newEvent.setObject(PFUser.currentUser()!.objectId!, forKey: "speaker")
        newEvent.setObject(self.startTime!, forKey: "startTime")
        newEvent.saveInBackground()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
