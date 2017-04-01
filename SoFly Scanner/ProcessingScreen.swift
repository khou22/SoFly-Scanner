//
//  ProcessingScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/1/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class ProcessingScreen: UIViewController {
    
    // Data
    var image: UIImage = UIImage()
    
    // Options
    var loadingTime = 6.0 // Number of seconds on loading screen
    
    // UI Elements
    @IBOutlet weak var iPhoneFull: UIImageView! // Faded iPhone
    @IBOutlet weak var iPhoneCropped: UIImageView! // iPhone to animate
    @IBOutlet weak var scannerBar: UIImageView! // Scanner bar
    @IBOutlet weak var completeScan: UIImageView!
    @IBOutlet weak var checkmarkHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scanningLabel: UILabel!
    
    override func viewDidLoad() {
        print("Processing...")
        
        self.completeScan.layer.opacity = 0.0
    }
    
    // Modify page layout
    override func viewDidLayoutSubviews() {
        setupAnimations() // Setup loading animations
        startAnimations() // Start animation
    }
    
    // Setup loading animations
    func setupAnimations() {
        // Calculate frames
        let targetFrame: CGRect = iPhoneFull.frame // Target frame
        print(targetFrame.maxY)
        let startingFrame: CGRect = CGRect(x: targetFrame.minX, y: targetFrame.maxY, width: targetFrame.width, height: 0) // Start with 0 height
        
        // Hide iPhone
        self.iPhoneCropped.frame = startingFrame // Starting frame
    }
    
    // Start the loading animations
    func startAnimations() {
        // Segue after x second(s)
        DispatchQueue.main.asyncAfter(deadline: .now() + self.loadingTime, execute: {
            self.performSegue(withIdentifier: Segues.processingToCompletion, sender: nil)
        })
        
        // Setup frames for animations
        let targetFrame: CGRect = iPhoneFull.frame // Target frame
        print(targetFrame.maxY)
        
        let originalBarcodeFrame: CGRect = scannerBar.frame // Original frame
        let targetBarcodeFrame: CGRect = CGRect(x: originalBarcodeFrame.minX, y: targetFrame.minY, width: originalBarcodeFrame.width, height: originalBarcodeFrame.height)
        
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseInOut], animations: {
            // Set to new frames
            self.iPhoneCropped.frame = targetFrame
            self.scannerBar.frame = targetBarcodeFrame
            
        }, completion: { completion in
            print("Processing complete")
            
            // Prepare checkmark for animation
            self.scanningLabel.isHidden = true
            self.checkmarkHeightConstraint.constant = 30 // Smaller than normal
            
            UIView.animate(withDuration: 0.3, delay: 0.25, options: [.curveEaseInOut], animations: {
                // Show checkmark
                self.completeScan.layer.opacity = 1.0
                self.checkmarkHeightConstraint.constant = 60 // Original
                self.view.layoutIfNeeded() // Update frontend
            }, completion: nil )
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If going to completion screen
        if (segue.identifier == Segues.processingToCompletion) {
            let completionScreen = segue.destination as! CompletionScreen // Get VC
            completionScreen.image = self.image // Pass on image
        }
    }
    
}
