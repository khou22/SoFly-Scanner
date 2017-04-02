//
//  CompletionScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

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
        }
        
        return true // End all
    }
    
    @IBAction func eventNameEdited(_ sender: AutocompleteTextField) {
        eventNameLabel.text = eventNameInput.text // Update label
        
        // If empty, add placeholder text
        if (eventNameInput.text == "") {
            eventNameLabel.text = "Add Event Name"
        }
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
