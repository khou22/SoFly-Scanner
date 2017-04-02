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
    
    override func viewDidLoad() {
        print("Completion screen loaded")
    }
    
    override func viewDidLayoutSubviews() {
        label.text = self.randomText
        posterImage.image = self.image
    }
    
    @IBAction func eventNameChanged(_ sender: Any) {
        eventNameLabel.text = eventNameInput.text // Update label
        
        // If empty, add placeholder text
        if (eventNameInput.text == "") {
            eventNameLabel.text = "Add Event Name"
        }
    }
    
    @IBAction func locationChanged(_ sender: Any) {
        
    }
    
    @IBAction func restartProcess(_ sender: Any) {
        performSegue(withIdentifier: Segues.completeToCamera, sender: nil)
    }
}
