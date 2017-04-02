//
//  CompletionScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CompletionScreen: UIViewController {
    
    var image: UIImage = UIImage() // Store image
    var randomText: String = ""
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var randomLabel: UILabel!
    
    // UI Elements
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    // Form Elements
    @IBOutlet weak var eventNameInput: AutocompleteTextField!
    @IBOutlet weak var locationInput: AutocompleteTextField!
    
    override func viewDidLayoutSubviews() {
        label.text = self.randomText
        posterImage.image = self.image // Add poster image
        
        // Add border
        posterImage.layer.borderColor = Colors.lightPurple.cgColor
        posterImage.layer.borderWidth = 2.0
        
        // Add button border
        self.locationInput.addBottomBorder()
        self.eventNameInput.addBottomBorder()
        
        eventNameInput.nextTextField = locationInput // Setup next responder
        locationInput.nextTextField = UITextField() // No next
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
}
