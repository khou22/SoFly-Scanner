//
//  CompletionScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class CompletionScreen: UIViewController, UITextFieldDelegate {
    
    var image: UIImage = UIImage() // Store image
    var event: ScannedEvent = ScannedEvent(with: "Event name...", location: "Location...", startDate: Date(), endDate: Date(), preprocessed: "Preprocessed text...") // Empty
    @IBOutlet weak var label: UILabel!
    
    // UI Elements
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    
    // Form Elements
    @IBOutlet weak var eventNameInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    
    override func viewDidLoad() {
        hideKeyboardOnSwipe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        posterImage.image = self.image // Add poster image
        
        eventNameInput.delegate = self
        locationInput.delegate = self
        
        // Fill in UI
        label.text = event.preprocessed // Add summary
        eventNameInput.text = event.name
        eventNameLabel.text = event.name
        locationInput.text = event.location
        
        startTimeButton.setTitle(stringFrom(date: event.startDate), for: .normal)
        endTimeButton.setTitle(stringFrom(date: event.endDate), for: .normal)
        
        refreshTimeLabel() // Update time labels
        
        // Add border
        posterImage.layer.borderColor = Colors.lightPurple.cgColor
        posterImage.layer.borderWidth = 2.0
        
        // Add button border
        self.locationInput.addBottomBorder()
        self.eventNameInput.addBottomBorder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == eventNameInput) {
            locationInput.becomeFirstResponder()
        } else if (textField == locationInput) {
            dismissKeyboard()
        }
        
        return true // End all
    }
    
    @IBAction func eventNameEdited(_ sender: AutocompleteTextField) {
        eventNameLabel.text = eventNameInput.text // Update label
        event.name = eventNameInput.text!
    }
    
    @IBAction func locationEdited(_ sender: Any) {
        event.location = locationInput.text!
    }
    
    @IBAction func restartProcess(_ sender: Any) {
        performSegue(withIdentifier: Segues.completeToCamera, sender: nil)
    }
    
    // Pressed start date
    @IBAction func startDatePressed(_ sender: Any) {
    }
    
    
    // Pressed end date
    @IBAction func endDatePressed(_ sender: Any) {
        
    }
    
    // Add to calendar
    @IBAction func addToCalendar(_ sender: Any) {
        let calendarManager: CalendarManager = CalendarManager()
        
        let calEvent: EKEvent = EKEvent(eventStore: calendarManager.eventStore)
        
        calEvent.title = eventNameInput.text!
        calEvent.location = locationInput.text
        
        // Set the calendar
        calEvent.calendar = calendarManager.eventStore.defaultCalendarForNewEvents // Default calendar
        
        calEvent.startDate = event.startDate
        calEvent.endDate = event.endDate
        calEvent.isAllDay = false // Not all day
        
        let defaultAlert: EKAlarm = EKAlarm(relativeOffset: -15 * 60) // Set alert before event time
        calEvent.addAlarm(defaultAlert) // Add default alert
        
        calendarManager.requestAccess(completion: { completion in
            if (completion == true) {
                calendarManager.saveEvent(event: calEvent) // Save event
                return
            }
        })
    }
    
    // Share
    @IBAction func shareWithFriends(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateStr: String = dateFormatter.string(from: event.startDate)
        let textToShare: String = "Come to " + eventNameInput.text! + " with me on " + dateStr + " at " + locationInput.text! + "!"
        
        var objectsToShare = [AnyObject]()
        objectsToShare.append(textToShare as AnyObject)
        objectsToShare.append(image)
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
            
        present(activityViewController, animated: true, completion: nil)
    }
    
    func stringFrom(date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
    
    func refreshTimeLabel() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let date: String = dateFormatter.string(from: event.startDate)
        let time: String = timeFormatter.string(from: event.startDate)
        
        eventDateLabel.text = date
        eventTimeLabel.text = time
    }
}
