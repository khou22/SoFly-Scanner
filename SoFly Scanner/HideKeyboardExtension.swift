//
//  HideKeyboardExtension.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/2/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

// Extends all UIViewControllers
extension UIViewController {
    
    func hideKeyboardOnSwipe() {
        // When UIViewController (not keyboard) is swiped down, dismiss keyboard
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeDown.direction = .down // Swipe down
        swipeDown.cancelsTouchesInView = false // Won't override UICollection/UITableView View selection
        
        // When double tapping hide keyboard
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        doubleTap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(swipeDown) // Add gesture to view
        view.addGestureRecognizer(doubleTap) // Add touble tap to view
    }
    
    // Dismiss keyboard
    func dismissKeyboard() {
        view.endEditing(true) // End keyboarding editing
    }
}
