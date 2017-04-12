//
//  ViewController.swift
//  Days From Today
//
//  Created by Brandon Everett on 8/24/15.
//  Copyright © 2015 Brandon Everett. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import iAd
import Timepiece

class ViewController: UIViewController, EKEventEditViewDelegate {
    
    @IBOutlet weak var numberOfDaysText: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var futureDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //display ads
        self.canDisplayBannerAds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var addToCalendarbtn: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard
        numberOfDaysText.resignFirstResponder()
    }
    
    @IBAction func findDatePress(_ sender: AnyObject) {
        
        //we will know this is a number
        //becase we are using a number padr
        let components: DateComponents = DateComponents()
        if  Int(numberOfDaysText.text!) == nil{
            //check if nothing has been entered
            let alertController = UIAlertController(title: "", message:
                "Please enter a valid number.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            addToCalendarbtn.isEnabled = false
            resultLabel.text = ""
            return
        }
        //if a value is entered asign the value to the variable
        let numOfDays = Int(numberOfDaysText.text!)!
        
        (components as NSDateComponents).setValue(numOfDays, forComponent: NSCalendar.Unit.day);
        let date: Date = Date()
        let newDate = (Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let strDate = dayTimePeriodFormatter.string(from: newDate!)
        resultLabel.text = "In \(numOfDays) days, the date will be \n \(strDate)."
        
        numberOfDaysText.resignFirstResponder()
        futureDate = newDate!
        //if this completes then we can enable the button 
        addToCalendarbtn.isEnabled = true
        
    }
    
    @IBAction func addToCalendarPress(_ sender: AnyObject) {
        
        //add the event to the calander
        //first check to see if the future date is actually valid
        //create the store
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.startDate = self.futureDate
                event.endDate = self.futureDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                let eventKitVC = EKEventEditViewController()
                eventKitVC.event = event
                
                //eventKitVC.allowsEditing = true
                eventKitVC.editViewDelegate = self
                //present the viewcontroller to allow the user to edit the event
                
                self.present(eventKitVC, animated: true, completion: nil)
            } else {
                
                //if no cal
                let alertController = UIAlertController(title: "", message:
                    "Access to your calendar has not been granted. Please go into your device settings to allow calendar access.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
       
    }
    
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        //dismiss the view controller when done 
        self.dismiss(animated: true, completion: nil)
    }
}

