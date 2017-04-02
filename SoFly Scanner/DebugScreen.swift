//
//  ProcessingScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class DebugScreen: UIViewController {
    
    var image: UIImage = UIImage()
    @IBOutlet weak var ocrText: UILabel!
    @IBOutlet weak var testUIImage: UIImageView!
    
    override func viewDidLoad() {
        print("Processing screen loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        testUIImage.image = ImageProcessing.prepareImage(image: image) // Set image
    }
    
    @IBAction func processData(_ sender: Any) {
        print("Processing")
        ocrText.text = "Processing..."
        
        DispatchQueue.global(qos: .background).async {
            let preprocessed = ImageProcessing.testing(image: self.image) // Testing
            
            DispatchQueue.main.async { // Back on the main thread
                self.ocrText.text = preprocessed // Set text
            }
        }
    }
}
