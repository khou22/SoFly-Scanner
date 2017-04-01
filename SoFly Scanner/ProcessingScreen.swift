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
    
    // UI Elements
    @IBOutlet weak var iPhoneFull: UIImageView! // Faded iPhone
    @IBOutlet weak var iPhoneCropped: UIImageView! // iPhone to animate
    @IBOutlet weak var scannerBar: UIImageView! // Scanner bar
    
    override func viewDidLoad() {
        print("Processing...")
    }
    
    // Modify page layout
    override func viewDidLayoutSubviews() {
        setupAnimations() // Setup loading animations
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimations() // Start animation
    }
    
    // Setup loading animations
    func setupAnimations() {
        // Calculate frames
        let targetFrame: CGRect = iPhoneFull.frame // Target frame
        let startingFrame: CGRect = CGRect(x: targetFrame.minX, y: targetFrame.maxY, width: targetFrame.width, height: 0) // Start with 0 height
        
        // Hide iPhone
        self.iPhoneCropped.frame = startingFrame // Starting frame
    }
    
    // Start the loading animations
    func startAnimations() {
        // Setup frames for animations
        let targetFrame: CGRect = iPhoneFull.frame // Target frame
        
        let originalBarcodeFrame: CGRect = scannerBar.frame // Original frame
        let targetBarcodeFrame: CGRect = CGRect(x: originalBarcodeFrame.minX, y: targetFrame.minY, width: originalBarcodeFrame.width, height: originalBarcodeFrame.height)
        
        UIView.animate(withDuration: 2.0, delay: 0.2, options: [.curveEaseInOut], animations: {
            // Set to new frames
            self.iPhoneCropped.frame = targetFrame
            self.scannerBar.frame = targetBarcodeFrame
            
        }, completion: { completion in
            print("Processing complete")
            self.performSegue(withIdentifier: Segues.processingToCompletion, sender: nil)
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
