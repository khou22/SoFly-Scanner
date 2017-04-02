//
//  TextFieldExtension.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/2/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    // Set border to none in Storyboard and then call this function to add just a bottom border
    func addBottomBorder() {
        let bottomBorder = CALayer()
        let width = CGFloat(1.0) // Border width
        bottomBorder.borderColor = Colors.red.cgColor // Border color
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height) // Frame
        
        bottomBorder.borderWidth = width // Apply border width
        self.layer.addSublayer(bottomBorder) // Add to text field
        self.layer.masksToBounds = true
    }
    
    // MARK - Add done button to number keyboard
    // Source: https://gist.github.com/jplazcano87/8b5d3bc89c3578e45c3e
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50)) // Create keyboard toolbar
        doneToolbar.barStyle = .default // Set style
        
        let blankFlexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // Add blank spacing item to left of done button
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction)) // Add done button
        
        doneToolbar.items = [blankFlexSpace, doneButton] // Create array of the items and add to toolbar
        doneToolbar.sizeToFit() // Fit to screen size
        
        self.inputAccessoryView = doneToolbar // Add toolbar to keyboard
        
    }
    
    // Function called when done button pressed
    func doneButtonAction() {
        self.resignFirstResponder() // Desselect
    }
    
    // MARK - End of adding done button to number pad
    
}
